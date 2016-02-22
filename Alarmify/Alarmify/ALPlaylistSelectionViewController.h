//
//  ALPlaylistSelectionViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AppDelegate.h"
#import "ALSpotifyManager.h"
#import "ALUser.h"

@interface ALPlaylistSelectionViewController : UIViewController
<
NSURLConnectionDelegate,
SPTAudioStreamingPlaybackDelegate,
SPTAudioStreamingDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic) SPTSession *session;
@property (nonatomic)SPTAudioStreamingController *audioPlayer;

@property (nonatomic) SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic)NSMutableArray *trackURIs;


@property(nonatomic) NSMutableArray *playlists;
@property NSMutableArray *songs;

@property (nonatomic, weak) NSString *songURI;
@property (strong, nonatomic) NSNumber *selected;

- (void)reloadTableViewWithPlaylists;
- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object;
-(void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist;

@end
