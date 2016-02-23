//
//  ALSpotifyManager.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSpotifyManager.h"
#import "ALUser.h"

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

+ (void)launchSpotifyFromViewController:(UIViewController *)presentingViewController
{    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *redirectString = @"alarmify://authorize";
    NSURL *redirectURL = [NSURL URLWithString:redirectString];
    

    [[SPTAuth defaultInstance] setRedirectURL:redirectURL];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope, SPTAuthUserReadPrivateScope]];
    
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:loginURL];
    [presentingViewController presentViewController:safariVC animated:YES completion:nil];
}

@end
