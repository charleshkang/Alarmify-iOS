//
//  ALSignInViewController.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Spotify/Spotify.h>
#import <SafariServices/SafariServices.h>

#import "ALSignInViewController.h"
#import "ALUser.h"
#import "ALSpotifyManager.h"
#import "ALSpotifyLogin.h"
#import "ALAlarmsTableViewController.h"

@interface ALSignInViewController () <SPTAuthViewDelegate>

@property (nonatomic) BOOL spotifyPremium;
@property (nonatomic) NSString *accessToken;

@property (nonatomic) SPTAuthViewController *authViewController;
@property (nonatomic) ALAlarmsTableViewController *alarmsTableVC;

@end

@implementation ALSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    SPTAuth *auth = [SPTAuth defaultInstance];
    //
    //    if (auth.session == nil) {
    //        [self openLogInPage];
    //    }
    //    else if ([auth.session isValid]) {
    //        //        [self.navigationController performSegueWithIdentifier:@"alarmsTableViewIdentifier" sender:self];
    //        //        [self presentViewController:self.alarmsTableVC animated:NO completion:nil];
    //    }
    //    else if (![auth.session isValid] && auth.hasTokenRefreshService) {
    //        [self renewTokenAndSegue];
    //
    //    }
    
}

- (IBAction)userLoggedInWithSpotify:(id)sender {
    [self openLogInPage];
    
}

//- (IBAction)getPlaylistsButtonTapped:(id)sender {
//    
//    NSString *username = [ALUser currentUser].username;
//    NSString *accessToken = [ALUser currentUser].accessToken;
//    
//    NSURLRequest *playlistRequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:username withAccessToken:accessToken error:nil];
//    [[SPTRequest sharedHandler] performRequest:playlistRequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
//        NSURL *baseURL = [NSURL URLWithString:@"https://open.spotify.com/track/023H4I7HJnxRqsc9cqeFKV"];
//
//        [SPTPlaylistSnapshot playlistWithURI:baseURL accessToken:accessToken callback:^(NSError *error, id object) {
//            
//        }];
//        if (error != nil) {
//            NSLog(@"playlist: %@, %@", playlistRequest, data);
//        }
//        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
//        NSLog(@"got charles' playlists, %@", playlists);
//        
//    }];

    //    NSURLRequest *playlistrequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:@"charleshyowonkang" withAccessToken:_accessToken error:nil]; [[SPTRequest sharedHandler] performRequest:playlistrequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
    //        if (error != nil) { NSLog(@"error");
    //        }
    //        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
    //        NSLog(@"Got possan's playlists, first page: %@", playlists);
    //        NSURLRequest *playlistrequest2 = [playlists createRequestForNextPageWithAccessToken:_accessToken error:nil];
    //
    //        [[SPTRequest sharedHandler] performRequest:playlistrequest2 callback:^(NSError *error2, NSURLResponse *response2, NSData *data2) {
    //            if (error2 != nil) {
    //                NSLog(@"error2");
    //            }
    //            SPTPlaylistList *playlists2 = [SPTPlaylistList playlistListFromData:data2 withResponse:response2 error:nil];
    //            NSLog(@"Got possan's playlists, second page: %@", playlists2);
    //        }];}];
//}


-(void) openLogInPage {
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    //    self.authViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
    
}

-(void) authenticationViewController:(SPTAuthViewController *)authenticationViewController didFailToLogin:(NSError *)error {
    NSLog(@"Authentication failed : %@",error);
    
}

-(void) authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session {
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSLog(@"auth token: %@", auth);
    
    [SPTUser requestCurrentUserWithAccessToken:session.accessToken callback:^(NSError *error, SPTUser *object) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            ALUser *currentUser = [ALUser currentUser];
            
            auth.sessionUserDefaultsKey = object.canonicalUserName;
            
        }];
    }];
}

-(void) authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController {
    [self openLogInPage];
}

-(void)renewTokenAndSegue {
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
