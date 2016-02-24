//
//  ALSongsTableViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/23/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSongsTableViewController.h"
#import "ALPlaylistsTableViewController.h"
#import <Spotify/Spotify.h>
#import "ALUser.h"

@interface ALSongsTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ALUser *user;
@property (nonatomic) NSInteger currentSongIndex;

@property (nonatomic) ALPlaylistsViewController *musicVC;

@property (nonatomic) SPTPlaylistTrack *tracksInPlaylists;
@property (nonatomic) NSMutableArray *trackURIs;
@property (nonatomic) SPTTrack *currentTrack;
@property (nonatomic) SPTArtist *currentArtist;
@property (nonatomic) SPTPartialPlaylist *playlist;
@property (nonatomic) SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic) UILabel *trackLabel;

@end

@implementation ALSongsTableViewController

@dynamic tableView;

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.user = [ALUser user];
    self.songs = [NSMutableArray new];
    self.currentTrack = [SPTTrack new];
    self.trackURIs = [NSMutableArray new];
}

- (void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist
{
    if (partialPlaylist) {
        [SPTRequest requestItemAtURI:partialPlaylist.uri withSession:self.session callback:^(NSError *error, id object) {
            if ([object isKindOfClass:[SPTPlaylistSnapshot class]]) {
                self.currentPlaylist = (SPTPlaylistSnapshot *)object;
                [self.trackURIs removeAllObjects];
                NSLog(@"Playlist Size: %lu", (unsigned long) self.currentPlaylist.trackCount);
                unsigned int trackCount = 0;
                if (self.currentPlaylist.tracksForPlayback > 0) {
                    for (SPTTrack *track in self.currentPlaylist.tracksForPlayback) {
                        NSLog(@"Got songs!: %u %@", trackCount, track.name);
                        trackCount++;
                        [self.trackURIs addObject:track.uri];
                    }
                    [self handleNewSession];
                }
            }
        }];
    }
}

- (void)handleNewSession
{
    self.currentSongIndex = 0;
    self.currentTrack = [self.currentPlaylist.tracksForPlayback objectAtIndex:self.currentSongIndex];
    self.trackLabel.text = self.currentTrack.name;
}

#pragma mark - Tableview Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songsIdentifier" forIndexPath:indexPath];
    NSString *songsName;
    
    SPTPlaylistTrack *playlistTrack = [self.songs objectAtIndex:indexPath.row];
    songsName = playlistTrack.name;
    [cell.textLabel setText:songsName];
    NSLog(@"Tracks: %@", playlistTrack.name);
    NSLog(@"Songs: %@", songsName);
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songs.count;
}

@end
