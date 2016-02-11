//
//  ALSpotifyManager.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Spotify/Spotify.h>

@interface ALSpotifyManager : NSObject

@property NSMutableArray<NSString *> *userPlaylists;

@property NSMutableDictionary *userInfo;

+ (void)addTrackToPlaylist:(NSString *)trackURI
                completion:(void(^)(BOOL success))completion;

@end
