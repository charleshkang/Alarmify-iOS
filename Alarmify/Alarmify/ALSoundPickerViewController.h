//
//  ALSoundPickerViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/12/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AppDelegate.h"
#import "ALSpotifyManager.h"
#import "ALUser.h"


@interface ALSoundPickerViewController : UIViewController
<NSURLConnectionDelegate,
SPTAudioStreamingPlaybackDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property MPMusicPlayerController *musicPlayer;
@property NSMutableArray *songs;
@property (strong, nonatomic) NSArray *playlists;
@property (strong, nonatomic) NSNumber *selected;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;


@end
