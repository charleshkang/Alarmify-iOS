//
//  ALSignInViewController.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Spotify/Spotify.h>

#import "ALSignInViewController.h"
#import "ALUser.h"
#import "ALSpotifyManager.h"
#import "ALKeys.h"

#import "ALAlarmsViewController.h"

@interface ALSignInViewController ()
<
SPTAuthViewDelegate
>

@property (nonatomic) SPTAuthViewController *authViewController;
@property (nonatomic) ALUser *user;

@end

@implementation ALSignInViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (auth.hasTokenRefreshService) {
        [self renewAccessToken];
        return;
    }
}

#pragma mark - Spotify Login & Auth Implementation

- (IBAction)userLoggedInWithSpotify:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.user) {
        [defaults setBool:YES forKey:@"hasLaunchedOnce"];
        [defaults setBool:YES forKey:@"UserLoggedIn"];
        ALAlarmsViewController *alarmsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"alarmsViewController"];
        [self presentViewController:alarmsVC animated:YES completion:nil];
        [defaults synchronize];
    }
    
    [self login];
}

- (void)checkIfSessionIsValid {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (auth.session == nil) {
        [self login];
    } else ([auth.session isValid] && [auth hasTokenRefreshService]); {
        [self renewAccessToken];
    }
}

- (void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session
{
    ALAlarmsViewController *alarmsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"alarmsViewController"];
    [self.navigationController pushViewController:alarmsVC animated:YES];
    
    [[ALUser user] handle:session];
    
}

- (void)login
{
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
}

- (void)renewAccessToken
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        if (error) {
            NSLog(@"Error renewing session: %@", error);
            return;
        }
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void)authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController
{
    [self login];
}

- (void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didFailToLogin:(NSError *)error
{
    NSLog(@"Authentication Failed : %@", error);
}

@end
