//
//  ALPlaylistsViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/22/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

#import "AppDelegate.h"
#import "ALSpotifyManager.h"


@interface ALPlaylistsViewController : UIViewController

@property (nonatomic) ALPlaylistsViewController *playlistsVC;

@property (nonatomic) SPTSession *session;
@property (nonatomic) SPTAudioStreamingController *audioPlayer;
@property (nonatomic) SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic) NSMutableArray *trackURIs;
@property NSMutableArray *songs;

@property (nonatomic, weak) NSString *songURI;
@property (strong, nonatomic) NSNumber *selected;

- (void)reloadTableViewWithPlaylists;
- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object;
- (void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist;

-(void)reload;

@end
