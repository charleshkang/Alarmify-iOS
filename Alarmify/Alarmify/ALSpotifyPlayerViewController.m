//
//  ALSpotifyPlayerViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSpotifyPlayerViewController.h"
#import "ALPlaylistsViewController.h"
#import "ALSpotifyManager.h"

@interface ALSpotifyPlayerViewController ()

@end

@implementation ALSpotifyPlayerViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playbackIndicator = [[UIView alloc] initWithFrame:rect(0,0,0,0)];
    self.playbackIndicator.backgroundColor = hex(0x1c9ba0);
    [self.view addSubview:self.playbackIndicator];
    [self.view sendSubviewToBack:self.playbackIndicator];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: rect(-1000, -1000, 0, 0)];
    [volumeView setUserInteractionEnabled:NO];
    volumeView.showsRouteButton = NO;
    [self.view addSubview: volumeView];
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    
    NC_addObserver(@"AUTH_OK", @selector(preparePlayerView:));
    NC_addObserver(@"AUTH_ERROR", @selector(preparePlayerView:));
    NC_addObserver(@"selectPlaylistIdentifier", @selector(changePlaylist:));
}

#pragma mark - Spotify Music Implementation

- (IBAction)playMusicButtonTapped:(id)sender
{
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    
    if (controller.player.isPlaying){
        [controller.player setIsPlaying:!controller.player.isPlaying callback:nil];
        
    }
}

- (IBAction)pauseMusicButtonTapped:(id)sender
{
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    [controller.player skipNext:^(NSError *error) {
        [self itemChangeCallback];
    }];
}

- (void)preparePlayerView:(NSNotification*)notification
{
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

- (BOOL)nextSongsFrom:(SPTListPage *)list
{
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

- (void)changePlaylist:(NSNotification *)notification
{
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

- (void)updateTrackLabels
{
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

- (void)itemChangeCallback
{
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

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata
{
    [self updateTrackLabels];
}

@end