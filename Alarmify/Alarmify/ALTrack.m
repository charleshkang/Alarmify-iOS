//
//  ALTrack.m
//  Alarmify
//
//  Created by Charles Kang on 2/12/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALTrack.h"

@implementation ALTrack

-(instancetype)initWithSongTitle:(NSString *)title artistName:(NSString *)artist albumName:(NSString *)album spotifyURL:(NSURL *)url coverArt:(NSData *)cover songPopularity:(NSNumber *)popularity spotifyLogo:(UIImage *)logo {
    self = [super init];
    if (self) {
        _songTitle = title;
        _artistName = artist;
        _albumName = album;
        _spotifyURI = url;
        _albumCoverArt = cover;
        _songPopularity = popularity;
        _spotifyLogo = logo;
    }
    return self;
}

@end
