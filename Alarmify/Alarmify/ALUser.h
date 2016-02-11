//
//  ALUser.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALUser : NSObject

@property NSMutableArray<NSString *> *playlists;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *accessToken;

@property (nonatomic, strong) void(^onLoginCallback)();

+ (ALUser *)currentUser;
- (BOOL)isLoggedInToSpotify;
- (void)loginToSpotify;

@end
