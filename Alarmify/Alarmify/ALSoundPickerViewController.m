//
//  ALSoundPickerViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/12/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSoundPickerViewController.h"
#import "ALAddAlarmTableViewController.h"
#import "ALSpotifyManager.h"

@interface ALSoundPickerViewController ()

@end

@implementation ALSoundPickerViewController

@synthesize artistLabel;
@synthesize songTitle;
@synthesize albumTitle;
@synthesize playlistLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    
    NC_addObserver(@"AUTH_OK", @selector(preparePlayerView:));
    NC_addObserver(@"AUTH_ERROR", @selector(preparePlayerView:));
    NC_addObserver(@"selectPlaylistIdentifier", @selector(changePlaylist:));
}

- (void)preparePlayerView:(NSNotification*) notification {
    
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    
    if([notification.userInfo[@"session"] isEqual:@"ERROR"]) {
        [[SPTAuth defaultInstance] setTokenSwapURL:nil];
        [[SPTAuth defaultInstance] setTokenRefreshURL:nil];
        return;
    }
    
    if([notification.userInfo[@"session"] isEqual:@"RESTORE"]) {
        
        SPTSession *restored = [NSKeyedUnarchiver unarchiveObjectWithData:UD_getObj(@"PLSessionPersistKey")];
        NSLog(@"restored Session: %@", restored);
        controller.session = restored;
        
        [SPTPlaylistList playlistsForUserWithSession:controller.session callback:^(NSError *error, id object) {
            controller.playlists = object;
        }];
        
        [SPTRequest savedTracksForUserInSession:controller.session callback:^(NSError *error, id object) {
            SPTListPage *mlist = (SPTListPage *)object;
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            
            NSLog(@"my music: %@",mlist);
            for (SPTSavedTrack *i in mlist.items) {
                [controller.myMusic addObject:i.uri];
            }
            if (mlist.hasNextPage) [self nextSongsFrom:mlist];
            [controller.player playURIs:controller.myMusic fromIndex:0 callback:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"*** Starting playback got error: %@", error);
                    return;
                }
                [self updateTrackLabels];
                
            }];
            
        }];
        return;
    }
    
    [controller.player loginWithSession:controller.session callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in got error: %@", error);
            return;
        }
        
        UD_setObj(@"PLSessionPersistKey", [NSKeyedArchiver archivedDataWithRootObject:controller.session]);
        NSLog(@"saved Session: %@", controller.session);
        
        controller.player.playbackDelegate = self;
        controller.player.shuffle = true;
        
        [SPTPlaylistList playlistsForUserWithSession:controller.session callback:^(NSError *error, id object) {
            controller.playlists = object;
        }];
        
        [SPTRequest savedTracksForUserInSession:controller.session callback:^(NSError *error, id object) {
            SPTListPage *mlist = (SPTListPage *)object;
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            
            NSLog(@"my music: %@",mlist);
            for (SPTSavedTrack *i in mlist.items) {
                [controller.myMusic addObject:i.uri];
            }
            if (mlist.hasNextPage) [self nextSongsFrom:mlist];
            [controller.player playURIs:controller.myMusic fromIndex:0 callback:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"*** Starting playback got error: %@", error);
                    return;
                }
                [self updateTrackLabels];
                
            }];
            
        }];
        
    }];
    
}

- (BOOL)nextSongsFrom:(SPTListPage *)list {
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    [[SPTRequest sharedHandler] performRequest:[list createRequestForNextPageWithAccessToken:controller.session.accessToken error:nil] callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        SPTListPage *newlist = [SPTListPage listPageFromData:data withResponse:response expectingPartialChildren:true rootObjectKey:nil error:nil];
        for (SPTSavedTrack *i in newlist.items) {
            [controller.myMusic addObject:i.uri];
        }
        if (newlist.hasNextPage) {
            [self nextSongsFrom:newlist];
        }
    }];
    return false;
}

- (void)changePlaylist:(NSNotification *) notification {
    
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    NSDictionary *ui = notification.userInfo;
    controller.player.shuffle = true;
    
    if ([ui[@"selected"] integerValue] == -1) {
        
        [controller.player playURIs:controller.myMusic fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error2: %@", error);
                return;
            }
            [self updateTrackLabels];
        }];
        
    } else {
        NSInteger playlist = [ui[@"selected"] integerValue];
        [controller.player playURIs:@[((SPTPartialPlaylist *)(controller.playlists.items[playlist])).playableUri] fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            [self updateTrackLabels];
        }];
    }
}

- (void)updateTrackLabels {
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    /* Next item callback
     * Update the song label, background and start playing.
     */
    [SPTTrack trackWithURI:controller.player.currentTrackURI session:controller.session callback:^(NSError *error, id object) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.artistLabel.alpha = 0.3;
            self.albumTitle.alpha = 0.3;
            self.songTitle.alpha = 0.3;
        } completion:^(BOOL finished) {
            NSString *titleString = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataTrackName] uppercaseString];
            NSString *artistString = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataArtistName] uppercaseString];
            self.artistLabel.text = artistString;
            self.songTitle.text = titleString;
            self.albumTitle.text = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataAlbumName] uppercaseString];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.artistLabel.alpha = 1;
                self.albumTitle.alpha  = 1;
                self.songTitle.alpha   = 1;
            }];
        }];
    }];
}

//- (void)itemChangeCallback {
//    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
//    /* Next item callback
//     * Update the song label, background and start playing.
//     */
//    [SPTTrack trackWithURI:controller.player.currentTrackURI session:controller.session callback:^(NSError *error, id object) {
//
//        [UIView animateWithDuration:0.2 animations:^{
//            self.artistLabel.alpha = 0.3;
//            self.albumTitle.alpha = 0.3;
//            self.songTitle.alpha = 0.3;
//        } completion:^(BOOL finished) {
//            NSString *titleString = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataTrackName] uppercaseString];
//            NSString *artistString = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataArtistName] uppercaseString];
//            self.artistLabel.text = artistString;
//            self.songTitle.text = titleString;
//            self.albumTitle.text = [controller.player.currentTrackMetadata[SPTAudioStreamingMetadataAlbumName] uppercaseString];
//
//            [UIView animateWithDuration:0.2 animations:^{
//                self.artistLabel.alpha = 1;
//                self.albumTitle.alpha  = 1;
//                self.songTitle.alpha   = 1;
//            }];
//        }];
//    }];
//}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata {
    [self updateTrackLabels];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlist"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"playlist"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    SPTPartialPlaylist *playlist;
    
    switch (indexPath.row) {
            
        case 0:
            title.text = @"SAVED TRACKS";
        default:
            playlist = (SPTPartialPlaylist *) self.playlists[indexPath.row - 2];
            title.text = [playlist.name uppercaseString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *ui;
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
            ui = @{ @"selected": @(-1)};
            NC_postNotification(@"selected_playlist", ui);
            break;
            
        default:
            ui = @{ @"selected": @(indexPath.row - 2)};
            NC_postNotification(@"selected_playlist", ui);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
