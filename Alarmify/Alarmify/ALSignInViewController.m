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

- (void)viewWillAppear:(BOOL)animated
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (auth.hasTokenRefreshService) {
        [self renewToken];
        return;
    }
}

#pragma mark - Spotify Login & Auth Implementation

- (IBAction)userLoggedInWithSpotify:(id)sender
{
    [self openLogInPage];
}

- (void)checkIfSessionIsValid {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (auth.session == nil) {
        [self openLogInPage];
    } else ([auth.session isValid] && [auth hasTokenRefreshService]); {
        [self renewToken];
        NSLog(@"Session is: %@", self.session);
    }
}

- (void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[ALUser user] handle:session];
    
}

- (void)openLogInPage
{
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
}

- (void)renewToken
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
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
