//
//  ALSpotifyManager.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>

@interface ALSpotifyManager : NSObject <SPTAudioStreamingPlaybackDelegate>

@property(strong, nonatomic) SPTAudioStreamingController *player;
@property(strong, nonatomic) SPTSession *session;
@property(strong, nonatomic) SPTPlaylistList *playlists;
@property(strong, nonatomic) NSMutableArray *myMusic;

+ (ALSpotifyManager *)defaultController;

// Not important for now
@property NSMutableDictionary *userInfo;
@property NSMutableArray<NSString *> *userPlaylists;

+ (void)addTrackToPlaylist:(NSString *)trackURI
                completion:(void(^)(BOOL success))completion;
+ (void)getUserPlaylists:(NSArray *)userPlaylists
              completion:(void(^)())completion;

@end
