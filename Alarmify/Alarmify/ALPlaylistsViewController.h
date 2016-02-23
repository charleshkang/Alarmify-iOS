//
//  ALPlaylistsViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/22/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import <Spotify/Spotify.h>


@interface ALPlaylistsViewController : UIViewController

@property (nonatomic) ALPlaylistsViewController *playlistsVC;

@property (nonatomic) SPTSession *session;

@property NSMutableArray *songs;

@property (nonatomic, weak) NSString *songURI;
@property (strong, nonatomic) NSNumber *selected;

- (void)fetchPlaylistPageForSession:(SPTSession *)session error:(NSError *)error object:(id)object;
- (void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist;

-(void)reload;

@end
