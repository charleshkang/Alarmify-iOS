
//  ALPlaylistsTableViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/23/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALPlaylistsTableViewController.h"
#import "ALAddAlarmTableViewController.h"
#import "ALUser.h"
#import <Spotify/Spotify.h>

@interface ALPlaylistsTableViewController ()

@property (strong) IBOutlet UITableView *tableView;
@property (nonatomic) ALUser *user;
@property (nonatomic) NSInteger currentSongIndex;

@property (nonatomic) ALPlaylistsViewController *musicVC;

@property (nonatomic)SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic)NSMutableArray *trackURIs;
@property (nonatomic)SPTTrack *currentTrack;
@property (nonatomic)SPTArtist *currentArtist;

-(void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object;

@end

@implementation ALPlaylistsTableViewController

@dynamic tableView;

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.user = [ALUser user];
    self.playlists = [NSMutableArray new];
    
    [self reload];
}

- (void)reload
{
    [SPTRequest playlistsForUserInSession:self.user.spotifySession callback:^(NSError *error, id object) {
        [self fetchPlaylistPageForSession:self.user.spotifySession error:error object:object];
        NSLog(@"playlists: %@", object);
    }];
}

#pragma mark - Spotify Playlist Implementation

- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object
{
    if (error) {
        NSLog(@"Error fetching playlists, %@", error);
    } else {
        if ([object isKindOfClass:[SPTPlaylistList class]]) {
            SPTPlaylistList *playlistList = (SPTPlaylistList *)object;
            
            for (SPTPartialPlaylist *playlist in playlistList.items) {
                [self.playlists addObject:playlist];
            }
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Tableview Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistIdentifier" forIndexPath:indexPath];
    NSString *playlistName;
    
    SPTPartialPlaylist *partialPlaylist = [self.playlists objectAtIndex:indexPath.row];
    playlistName = partialPlaylist.name;
    [cell.textLabel setText:playlistName];
    
    NSLog(@"Playlists: %@", playlistName);
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"YO HERE ARE YOUR PLAYLISTS: %@", self.playlists);
    return self.playlists.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.currentSongIndex != indexPath.row){
        self.currentSongIndex = indexPath.row;
    }
    //    [self.navigationController pushViewController:self.musicVC animated:YES];
    NSLog(@"Do something...");
    
}

@end
