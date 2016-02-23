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

static ALUser *user = nil;


+ (ALUser *)user
{
    if (!user) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user = [self new];
        });
    }
    return user;
}

- (void)handle:(SPTSession *)session
{
    if (session) {
        _spotifySession = session;
    }
    [SPTRequest userInformationForUserInSession:session callback:^(NSError *error, id object) {
        if (!error) {
            self.spotifyUser = (SPTUser *)object;
            [self.playlistsVC reload];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end