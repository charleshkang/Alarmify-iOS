//
//  ALSpotifyPlayerViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ALSpotifyPlayerViewController : UIViewController
<
NSURLConnectionDelegate,
SPTAudioStreamingPlaybackDelegate
>

@property (nonatomic) MPMusicPlayerController *musicPlayer;
@property (nonatomic) NSArray *songs;
@property (nonatomic) UIImageView *launcher;

@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (strong, nonatomic) IBOutlet UIView *playbackIndicator;


- (IBAction) playPause:(id)sender;
- (IBAction) nextSong:(id)sender;
- (void) itemChangeCallback;



@end
