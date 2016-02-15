//
//  ALSpotifyManager.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ALSpotifyManager : NSObject <SPTAudioStreamingPlaybackDelegate>

@property(strong, nonatomic) SPTAudioStreamingController *player;
@property(strong, nonatomic) SPTSession *session;
@property(strong, nonatomic) SPTPlaylistList *playlists;
@property(strong, nonatomic) NSMutableArray *myMusic;

+ (ALSpotifyManager *)defaultController;

+ (void)launchSpotifyFromViewController:(UIViewController *)presentingViewController;

@end
