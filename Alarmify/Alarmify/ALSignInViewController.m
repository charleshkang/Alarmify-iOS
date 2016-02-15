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

@interface ALSignInViewController ()

@property (nonatomic) BOOL userIsPremiumUser;
@property (nonatomic) NSString *accessToken;

@property (nonatomic) SPTAuthViewController *authViewController;
@property (nonatomic) ALAlarmsTableViewController *alarmsTableVC;

@end

@implementation ALSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (IBAction)userLoggedInWithSpotify:(id)sender {
    [self createSpotifySession];
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    [[UIApplication sharedApplication] performSelector:@selector(openURL:)
                                            withObject:loginURL afterDelay:0.1];
}

- (void) openLogInPage {
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
    
}

- (void) authenticationViewController:(SPTAuthViewController *)authenticationViewController didFailToLogin:(NSError *)error {
    NSLog(@"Authentication failed : %@",error);
    
}

- (void) authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session {
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSLog(@"auth token: %@", auth);
    
    [SPTUser requestCurrentUserWithAccessToken:session.accessToken callback:^(NSError *error, SPTUser *object) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            ALUser *currentUser = [ALUser currentUser];
            
            auth.sessionUserDefaultsKey = object.canonicalUserName;
            
        }];
    }];
}

- (void) createSpotifySession {
    SPTSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:UD_getObj(@"PLSessionPersistKey")];
    NSLog(@"persisted Session: %@", session);
    if (session) {
        NSNotification *notification = [[NSNotification alloc] initWithName:@"AUTH_D" object:nil userInfo:@{@"session":@"RESTORE"}];
//        [self preparePlayerView:notification];
    } else {
        [[SPTAuth defaultInstance] setClientID:@"1b76daf6d74844989d3d9d7a9ae2a43c"];
        [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"alarmify://authorize"]];
        [[SPTAuth defaultInstance] setTokenSwapURL:[NSURL URLWithString:@"https://alarmify.herokuapp.com/swap"]];
        [[SPTAuth defaultInstance] setTokenRefreshURL:[NSURL URLWithString:@"https://alarmify.herokuapp.com/refresh"]];
        [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserLibraryReadScope]];
    }
}

- (void) authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController {
    [self openLogInPage];
}

- (void)renewTokenAndSegue {
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
    }];
}

- (void)sessionUpdatedNotification:(NSNotification *)notification {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (auth.session && [auth.session isValid])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
