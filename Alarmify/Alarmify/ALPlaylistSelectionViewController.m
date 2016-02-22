//
//  ALPlaylistSelectionViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALPlaylistSelectionViewController.h"
#import "ALAddAlarmTableViewController.h"
#import "ALSpotifyManager.h"
#import "ALUser.h"

@interface ALPlaylistSelectionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ALUser *spotifyUser;
@property (nonatomic) ALPlaylistSelectionViewController *musicPlayerVC;

@property (nonatomic) NSInteger currentSongIndex;

@end

@implementation ALPlaylistSelectionViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentSongIndex = -1;
    [self reloadTableViewWithPlaylists];
    
    NC_addObserver(@"AUTH_OK", @selector(preparePlayerView:));
    NC_addObserver(@"AUTH_ERROR", @selector(preparePlayerView:));
}

#pragma mark - Tableview Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistCellIdentifier" forIndexPath:indexPath];
    NSString *playlistName;
    
    SPTPartialPlaylist *partialPlaylist = [self.playlists objectAtIndex:indexPath.row];
    playlistName = partialPlaylist.name;
    [cell.textLabel setText:playlistName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.musicPlayerVC){
        self.musicPlayerVC = [ALPlaylistSelectionViewController new];
    }
    
    if(self.currentSongIndex != indexPath.row){
        self.currentSongIndex = indexPath.row;
        self.musicPlayerVC.session = self.spotifyUser.spotifySession;
        [self.musicPlayerVC setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)[self.playlists objectAtIndex:indexPath.row]];
    }
    [self.navigationController pushViewController:self.musicPlayerVC animated:YES];
    
}

- (void)reloadTableViewWithPlaylists
{
    [SPTRequest playlistsForUserInSession:self.spotifyUser.spotifySession callback:^(NSError *error, id object) {
        [self fetchPlaylistPageForSession:self.spotifyUser.spotifySession error:error object:object];
    }];
}

#pragma mark - Spotify Playlist Implementation

- (void)preparePlayerView:(NSNotification*) notification
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

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata
{
}

- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object
{
    if (error != nil) {
        NSLog(@"PLAYLIST ERROR");

    } else {
        if ([object isKindOfClass:[SPTPlaylistList class]]) {
            SPTPlaylistList *playlistList = (SPTPlaylistList *)object;
            
            for (SPTPartialPlaylist *playlist in playlistList.items) {
                NSLog(@"GOT PLAYLIST");
                [self.playlists addObject:playlist];
            }
            
            if (playlistList.hasNextPage) {
                NSLog(@"GETTING NEXT PAGE");
                [playlistList requestNextPageWithSession:session callback:^(NSError *error, id object) {
                    [self fetchPlaylistPageForSession:session error:error object:object];
                }];
            }
            [self.tableView reloadData];
        }
    }
}

-(void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist{
    if(partialPlaylist){
        [SPTRequest requestItemAtURI:partialPlaylist.uri withSession:self.session callback:^(NSError *error, id object) {
            if([object isKindOfClass:[SPTPlaylistSnapshot class]]){
                self.currentPlaylist = (SPTPlaylistSnapshot *)object;
                [self.trackURIs removeAllObjects];
                NSLog(@"PLAYLIST SIZE: %lu", (unsigned long)self.currentPlaylist.trackCount);
                unsigned int i = 0;
                if(self.currentPlaylist.trackCount > 0){
                    for(SPTTrack *track in self.currentPlaylist.tracksForPlayback){
                        NSLog(@"GOT SONG:%u %@ ", i, track.name);
                        i++;
                        [self.trackURIs addObject:track.uri];
                    }
                    [self handleNewSession];
                }
            }
        }];
    }
}

- (void)handleNewSession {
    SPTAuth *auth = [SPTAuth defaultInstance];
    self.currentSongIndex = 0;
    if (self.audioPlayer == nil) {
        self.audioPlayer = [[SPTAudioStreamingController alloc] initWithClientId:auth.clientID];
        self.audioPlayer.playbackDelegate = self;
        SPTVolume volume = 0.5;
        [self.audioPlayer setVolume:volume callback:^(NSError *error) {
            
        }];
        //self.audioPlayer.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
    }
    
    [self.audioPlayer loginWithSession:auth.session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
    }
     
     ];
}


@end
