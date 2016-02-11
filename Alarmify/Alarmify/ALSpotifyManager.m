//
//  ALSpotifyManager.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSpotifyManager.h"
#import "ALUser.h"

static NSString *playlistName = @"Alarmify";

@implementation ALSpotifyManager

+ (void)addTrackToPlaylist:(NSString *)trackURI
                completion:(void(^)(BOOL success))completion {
    
    if (!trackURI) {
        return;
    }
    
    //    NSString *username = [User currentUser].username;
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    [self findOrCreatePlaylist:@"Alarmify" completion:^(SPTPlaylistSnapshot *playlist) {
        if (playlist) {
            NSURL *trackURL = [NSURL URLWithString:trackURI];
            [SPTTrack tracksWithURIs:@[trackURL] accessToken:accessToken market:nil callback:^(NSError *error, id object) {
                NSArray *tracks = (NSArray *)object;
                SPTTrack *track = [tracks firstObject];
                [playlist addTracksToPlaylist:@[track] withAccessToken:accessToken callback:^(NSError *error) {
                    completion(error == nil);
                }];
            }];
        }
    }];
}

+ (void)findOrCreatePlaylist:(NSString *)playlist completion:(void(^)(SPTPlaylistSnapshot *playlist))completion {
    [self findPlaylist:^(SPTPlaylistSnapshot *playlist) {
        if (!playlist) {
            [self createPlaylist:^(SPTPlaylistSnapshot *playlist) {
                completion(playlist);
            }];
        } else {
            completion(playlist);
        }
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

+ (void)createPlaylist:(void(^)(SPTPlaylistSnapshot *playlist))completion {
    
    NSString *username = [ALUser currentUser].username;
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    [SPTPlaylistList createPlaylistWithName:@"Uncharted" forUser:username publicFlag:YES accessToken:accessToken callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        if (!error) {
            completion(playlist);
        }
    }];
}



@end
