//
//  ALSpotifyManager.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSpotifyManager.h"
#import "ALUser.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>


static NSString *playlistName = @"Alarmify";

@implementation ALSpotifyManager

static ALSpotifyManager *defaultSpotifyController = nil;

+ (ALSpotifyManager *)defaultController {
    if (defaultSpotifyController == nil) {
        defaultSpotifyController = [[super allocWithZone:NULL] init];
    }
    return defaultSpotifyController;
}

- (id)init {
    if ( (self = [super init]) ) {
        self.myMusic = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

+ (void)getUserPlaylists:(NSArray *)userPlaylists
              completion:(void(^)())completion {
    if (!userPlaylists) {
        return;
    }
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    [self findPlaylist:^(SPTPlaylistSnapshot *playlist) {
        
        
    }];
}

+ (void)findPlaylist:(void(^)(SPTPlaylistSnapshot *playlist))completion {
    
    NSString *username = [ALUser currentUser].username;
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    [SPTPlaylistList playlistsForUser:username withAccessToken:accessToken callback:^(NSError *error, id object) {
        BOOL found = NO;
        NSURL *uri = nil;
        
        if (!error) {
            SPTPlaylistList *list = (SPTPlaylistList *)object;
            for (SPTPartialPlaylist *item in list.items) {
                // THIS COULD BE A BUG
                if ([item.name isEqualToString:playlistName]) {
                    uri = item.uri;
                    found = YES;
                }
            }
        }
        
        if (found) {
            [SPTPlaylistSnapshot playlistWithURI:uri accessToken:accessToken callback:^(NSError *error, id object) {
                completion((SPTPlaylistSnapshot *)object);
            }];
        } else {
            completion(nil);
        }
        
    }];
}

@end
