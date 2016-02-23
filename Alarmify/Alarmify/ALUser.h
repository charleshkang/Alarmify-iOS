//
//  ALUser.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALPlaylistsTableViewController.h"

@class ALPlaylistsViewController;

@interface ALUser : NSObject

+ (ALUser *)user;
- (void)handle:(SPTSession *)session;

@property (nonatomic) SPTUser *spotifyUser;
@property (nonatomic) SPTSession *spotifySession;

@property (nonatomic) ALPlaylistsTableViewController *playlistsVC;

@end
