//
//  ALTrackManager.h
//  Alarmify
//
//  Created by Charles Kang on 2/12/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>

@interface ALTrackManager : NSObject

+(void)searchSpotifyForTrack:(NSString *)track WithCompletion:(void (^)(NSArray *trackList))completion;
+(void)getSingleTrackDataFromURI:(NSURL *)trackURI WithCompletion:(void (^)(NSDictionary *trackInfo))completion;
+(void)generateTracksFromSearch:(NSString *)searchKeyword WithCompletion:(void (^)(NSArray *tracks))completion;

@end
