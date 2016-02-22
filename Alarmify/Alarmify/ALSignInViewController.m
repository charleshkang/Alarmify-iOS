//
//  ALSignInViewController.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <SafariServices/SafariServices.h>

#import "ALSignInViewController.h"
#import "ALUser.h"
#import "ALSpotifyManager.h"
#import "ALSpotifyLogin.h"
#import "ALAlarmsTableViewController.h"
#import "ALAlarmsViewController.h"

@interface ALSignInViewController ()

@property (nonatomic) BOOL userIsLoggedIn;
@property (nonatomic) NSString *accessToken;

@property (nonatomic) SPTAuthViewController *authViewController;
@property (nonatomic) ALAlarmsTableViewController *alarmsTableVC;
@property (nonatomic) ALAlarmsViewController *alarmVC;
@property (nonatomic) SPTSession *session;

@end

@implementation ALSignInViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Spotify Login & Auth Implementation

- (IBAction)userLoggedInWithSpotify:(id)sender
{
    [self checkIfSessionIsValid];
    [self openLogInPage];
    [self segueIfUserIsLoggedIn];
}

- (void)checkIfSessionIsValid {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (auth.session == nil) {
        [self openLogInPage];
    } else ([auth.session isValid] && [auth hasTokenRefreshService]); {
        [self renewToken];
    }
}

- (void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [SPTUser requestCurrentUserWithAccessToken:session.accessToken callback:^(NSError *error, SPTUser *object) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            auth.sessionUserDefaultsKey = object.displayName;
        }];
    }];
}

- (void)openLogInPage
{
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
}

// WHY AREN'T YOU WORKING
- (void)segueIfUserIsLoggedIn
{
    SPTAuth *auth = [SPTAuth defaultInstance];

    if ([auth.session isValid] && [auth hasTokenRefreshService]) {
        [self performSegueWithIdentifier:@"loginSegueIdentifier" sender:nil];
        ALAlarmsViewController *alarmsVC = [[ALAlarmsViewController alloc] init];
        [self showViewController:alarmsVC sender:nil];
    }
}

- (void)renewToken
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
    }];
}

- (void)sessionUpdatedNotification:(NSNotification *)notification
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (auth.session && [auth.session isValid])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController
{
    [self openLogInPage];
}

- (void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didFailToLogin:(NSError *)error
{
    NSLog(@"Authentication Failed : %@",error);
}

@end
