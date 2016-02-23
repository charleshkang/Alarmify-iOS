//
//  ALSpotifyManager.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSpotifyManager.h"
#import "ALUser.h"
#import <Spotify/Spotify.h>

static NSString *playlistName = @"Alarmify";

@implementation ALSpotifyManager

static ALSpotifyManager *defaultSpotifyController = nil;

+ (ALSpotifyManager *)defaultController
{
    if (defaultSpotifyController == nil) {
        defaultSpotifyController = [[super allocWithZone:NULL] init];
    }
    return defaultSpotifyController;
}

- (id)init
{
    if ( (self = [super init]) ) {
        self.myMusic = [[NSMutableArray alloc] initWithCapacity:50];
    }
    return self;
}

@end
