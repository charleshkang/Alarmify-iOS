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

#define SPOTIFY_ACCESS_TOKEN_KEY @"alarmifyAccessToken"
#define SPOTIFY_USERNAME_KEY @"spotifyUsername"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSString *spotifyClientID;
@property (nonatomic) NSString *sessionUserDefaultsKey;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end

