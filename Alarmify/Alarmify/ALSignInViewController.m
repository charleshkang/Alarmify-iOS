//
//  ALSignInViewController.m
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALSignInViewController.h"
#import "ALUser.h"
#import "ALSpotifyManager.h"

@interface ALSignInViewController ()

@end

@implementation ALSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)premiumUserLoginTapped:(id)sender {
        
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

- (IBAction)freeUserLoginTapped:(id)sender {
    NSLog(@"free user signed in");
    
}

@end
