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
<NSURLConnectionDelegate,
SPTAudioStreamingPlaybackDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;


@property (nonatomic, weak) NSString *songURI;
@property MPMusicPlayerController *musicPlayer;
@property NSMutableArray *songs;
@property (strong, nonatomic) NSArray *playlists;
@property (strong, nonatomic) NSNumber *selected;

+ (void)addTrackToPlaylist:(NSString *)trackURI
                completion:(void(^)(BOOL success))completion;

@end
