//
//  AppDelegate.h
//  alarmify
//
//  Created by Charles Kang on 1/26/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define CLIENT_ID  @"1b76daf6d74844989d3d9d7a9ae2a43c"
#define CLIENT_SECRET @"0d4a159209a64db9bf4cf51b157c42f0"
#define SPOTIFY_ACCESS_TOKEN_KEY @"spotifyAccessToken"
#define SPOTIFY_USERNAME_KEY @"spotifyUsername"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

