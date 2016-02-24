//
//  ALSongsTableViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/23/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import "AppDelegate.h"

@interface ALSongsTableViewController : UITableViewController

@property (nonatomic) ALSongsTableViewController *songsVC;
@property (nonatomic) SPTSession *session;
@property (nonatomic) NSMutableArray *songs;

- (void)reloadWithSongs;

- (void)setPlaylistWithPartialPlaylist:(SPTPartialPlaylist *)partialPlaylist;

@end
