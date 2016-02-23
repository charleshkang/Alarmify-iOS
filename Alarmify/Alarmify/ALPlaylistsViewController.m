//
//  ALPlaylistsViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/22/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALPlaylistsViewController.h"
#import "ALAddAlarmTableViewController.h"
#import "ALUser.h"

@interface ALPlaylistsViewController ()
<
NSURLConnectionDelegate,
SPTAudioStreamingPlaybackDelegate,
SPTAudioStreamingDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ALUser *user;
@property (nonatomic) NSInteger currentSongIndex;
@property (nonatomic) NSMutableArray *playlists;

@property (nonatomic) ALPlaylistsViewController *musicVC;

@end

@implementation ALPlaylistsViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentSongIndex = -1;
    [self reload];
    
    self.user = [ALUser user];
    self.playlists = [NSMutableArray new];
}

- (void)reload
{
    [SPTRequest playlistsForUserInSession:self.user.spotifySession callback:^(NSError *error, id object) {
        [self fetchPlaylistPageForSession:self.user.spotifySession error:error object:object];
    }];
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
    
    NSLog(@"Playlists: %@", playlistName);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.currentSongIndex != indexPath.row){
        self.currentSongIndex = indexPath.row;
        self.musicVC.session = self.user.spotifySession;
        
        [self.musicVC setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)[self.playlists objectAtIndex:indexPath.row]];
    }
//    [self.navigationController pushViewController:self.musicVC animated:YES];
    NSLog(@"Do something...");
    
}

#pragma mark - Spotify Playlist Implementation

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

- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object
{
    if (error != nil) {
        NSLog(@"Error fetching playlists, %@", error);
        abort();
    } else {
        if ([object isKindOfClass:[SPTPlaylistList class]]) {
            SPTPlaylistList *playlistList = (SPTPlaylistList *)object;
            
            for (SPTPartialPlaylist *playlist in playlistList.items) {
                NSLog(@"Fetched playlists!");
                [self.playlists addObject:playlist];
            }
            
            if (playlistList.hasNextPage) {
                NSLog(@"Fetching more playlists...%@", playlistList);
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

