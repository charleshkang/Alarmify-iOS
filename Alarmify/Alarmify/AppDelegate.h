//
//  AppDelegate.h
//  alarmify
//
//  Created by Charles Kang on 1/26/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <CoreData/CoreData.h>

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import <MediaPlayer/MediaPlayer.h>

#define SPOTIFY_ACCESS_TOKEN_KEY @"alarmifyAccessToken"
#define SPOTIFY_USERNAME_KEY @"spotifyUsername"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@property (nonatomic) NSString *spotifyClientID;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

