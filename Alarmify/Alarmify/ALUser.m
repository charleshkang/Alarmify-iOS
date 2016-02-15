//
//  ALUser.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALUser.h"
#import "AppDelegate.h"
#import <Spotify/Spotify.h>

@implementation ALUser

+ (ALUser *)currentUser {
    static ALUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

- (NSString *)accessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SPOTIFY_ACCESS_TOKEN_KEY];
}

- (NSString *)username {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SPOTIFY_USERNAME_KEY];
}

- (BOOL)isLoggedInToSpotify {
    // User is logged into Spotify if access token is found in NSUserDefaults
    return [[NSUserDefaults standardUserDefaults] objectForKey:SPOTIFY_ACCESS_TOKEN_KEY] != nil;
    
}

@end