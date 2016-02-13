//
//  ALAlarmsViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/9/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALAlarmsViewController.h"
#import "ALUser.h"
#import <Spotify/Spotify.h>

@interface ALAlarmsViewController ()

@end

@implementation ALAlarmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPlaylistsButtonTapped:(id)sender {
    
    NSString *username = [ALUser currentUser].username;
    NSString *accessToken = [ALUser currentUser].accessToken;
    
    NSURLRequest *playlistRequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:username withAccessToken:accessToken error:nil];
    [[SPTRequest sharedHandler] performRequest:playlistRequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        NSURL *baseURL = [NSURL URLWithString:@"https://open.spotify.com/track/023H4I7HJnxRqsc9cqeFKV"];
        
        [SPTPlaylistSnapshot playlistWithURI:baseURL accessToken:accessToken callback:^(NSError *error, id object) {
            
        }];
        if (error != nil) {
            NSLog(@"playlist: %@, %@", playlistRequest, data);
        }
        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
        NSLog(@"got charles' playlists, %@", playlists);
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
