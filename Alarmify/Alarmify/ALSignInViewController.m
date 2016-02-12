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

@interface ALSignInViewController ()
@property (nonatomic) NSString *accessToken;

@end

@implementation ALSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)userLoggedInWithSpotify:(id)sender {
    
    SPTAuth *auth = [SPTAuth defaultInstance];
    ALUser *user = [ALUser currentUser];
    
    
    __block NSString *uri = self.songURI;
    void (^addTrack)() = ^void() {
        [ALSpotifyManager addTrackToPlaylist:uri completion:^(BOOL success) {
            if (success) {
                NSLog(@"success");
            } else {
                NSLog(@"fail");
            }
        }];
    };
    
    if (![[ALUser currentUser] isLoggedInToSpotify]) {
        [ALUser currentUser].onLoginCallback = ^{
            addTrack();
        };
        [[ALUser currentUser] loginToSpotify];
    } else {
        addTrack();
    }
}
- (IBAction)getPlaylistsButtonTapped:(id)sender {
    
    NSString *username = [ALUser currentUser].username;
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    NSURLRequest *playlistRequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:username withAccessToken:accessToken error:nil];
    [[SPTRequest sharedHandler] performRequest:playlistRequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        if (error != nil) {
            NSLog(@"error?");
        }
        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
        NSLog(@"got charles' playlists, %@", playlists);
        
    }];
    
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
}


-(void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didFailToLogin:(NSError *)error
{
    
}

-(void)authenticationViewController:(SPTAuthViewController *)authenticationViewController didLoginWithSession:(SPTSession *)session
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    [SPTUser requestCurrentUserWithAccessToken:session.accessToken callback:^(NSError *error, SPTUser *object) {
        
    }];
}

-(void)authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController
{
    
}


@end
