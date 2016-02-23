//
//  ALSpotifyManager.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Spotify/Spotify.h>

@interface ALSpotifyManager : NSObject
<
SPTAudioStreamingPlaybackDelegate,
SPTAudioStreamingDelegate
>

@property(strong, nonatomic) SPTAudioStreamingController *player;
@property(strong, nonatomic) SPTSession *session;
@property(strong, nonatomic) SPTPlaylistList *playlists;
@property(strong, nonatomic) NSMutableArray *myMusic;

+ (ALSpotifyManager *)defaultController;

@end
