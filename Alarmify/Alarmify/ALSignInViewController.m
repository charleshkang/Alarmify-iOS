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

@property (nonatomic) BOOL spotifyPremium;
@property (nonatomic) NSString *accessToken;

@property (nonatomic) SPTAuthViewController *authViewController;
@property (nonatomic) ALAlarmsTableViewController *alarmsTableVC;

@end

@implementation ALSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NC_addObserver(@"AUTH_OK", @selector(preparePlayerView:));
    NC_addObserver(@"AUTH_ERROR", @selector(preparePlayerView:));
    NC_addObserver(@"selectPlaylistIdentifier", @selector(changePlaylist:));
    
    SPTSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:UD_getObj(@"PLSessionPersistKey")];
    NSLog(@"persisted Session: %@", session);
    if (session) {
        NSNotification *notification = [[NSNotification alloc] initWithName:@"AUTH_D" object:nil userInfo:@{@"session":@"RESTORE"}];
//        [self preparePlayerView:n];
    }else {
        [[SPTAuth defaultInstance] setClientID:@"1b76daf6d74844989d3d9d7a9ae2a43c"];
        [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"alarmify://authorize"]];
        [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserLibraryReadScope]];
    }

}

- (IBAction)userLoggedInWithSpotify:(id)sender {
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    [[UIApplication sharedApplication] performSelector:@selector(openURL:)
                                            withObject:loginURL afterDelay:0.1];

//    [self openLogInPage];
    
}

- (BOOL) nextSongsFrom:(SPTListPage *)list {
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    [[SPTRequest sharedHandler] performRequest:[list createRequestForNextPageWithAccessToken:controller.session.accessToken error:nil] callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        SPTListPage *newlist = [SPTListPage listPageFromData:data withResponse:response expectingPartialChildren:true rootObjectKey:nil error:nil];
        for (SPTSavedTrack *i in newlist.items) {
            [controller.myMusic addObject:i.uri];
        }
        if (newlist.hasNextPage) {
            [self nextSongsFrom:newlist];
        }
    }];
    return false;
}

- (void) changePlaylist:(NSNotification *) notification {
    
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    NSDictionary *ui = notification.userInfo;
    controller.player.shuffle = true;
    
    if ([ui[@"selected"] integerValue] == -1) {
        
        [controller.player playURIs:controller.myMusic fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error2: %@", error);
                return;
            }
            [self itemChangeCallback];
        }];
        
    } else {
        NSInteger playlist = [ui[@"selected"] integerValue];
        [controller.player playURIs:@[((SPTPartialPlaylist *)(controller.playlists.items[playlist])).playableUri] fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            [self itemChangeCallback];
        }];
    }
}

- (void) preparePlayerView:(NSNotification*) notification {
    
    
    ALSpotifyManager *controller2 = [ALSpotifyManager defaultController];
    
    if([notification.userInfo[@"session"] isEqual:@"ERROR"]) {
        //[[SPTAuth defaultInstance] setTokenSwapURL:nil];
        //[[SPTAuth defaultInstance] setTokenRefreshURL:nil];
        return;
    }
    
    if([notification.userInfo[@"session"] isEqual:@"RESTORE"]) {
        
        SPTSession *restored = [NSKeyedUnarchiver unarchiveObjectWithData:UD_getObj(@"PLSessionPersistKey")];
        NSLog(@"restored Session: %@", restored);
        controller2.session = restored;
        
        [SPTPlaylistList playlistsForUserWithSession:controller2.session callback:^(NSError *error, id object) {
            controller2.playlists = object;
        }];
        
        [SPTRequest savedTracksForUserInSession:controller2.session callback:^(NSError *error, id object) {
            SPTListPage *mlist = (SPTListPage *)object;
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            
            NSLog(@"my music: %@",mlist);
            for (SPTSavedTrack *i in mlist.items) {
                [controller2.myMusic addObject:i.uri];
            }
            if (mlist.hasNextPage) [self nextSongsFrom:mlist];
            [controller2.player playURIs:controller2.myMusic fromIndex:0 callback:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"*** Starting playback got error: %@", error);
                    return;
                }
                
                [self itemChangeCallback];
                
            }];
            
        }];
        return;
    }
    
    [controller2.player loginWithSession:controller2.session callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in got error: %@", error);
            return;
        }
        
        UD_setObj(@"PLSessionPersistKey", [NSKeyedArchiver archivedDataWithRootObject:controller2.session]);
        NSLog(@"saved Session: %@", controller2.session);
        
        controller2.player.playbackDelegate = self;
        controller2.player.shuffle = true;
        
        [SPTPlaylistList playlistsForUserWithSession:controller2.session callback:^(NSError *error, id object) {
            controller2.playlists = object;
        }];
        
        [SPTRequest savedTracksForUserInSession:controller2.session callback:^(NSError *error, id object) {
            SPTListPage *mlist = (SPTListPage *)object;
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
            
            NSLog(@"my music: %@",mlist);
            for (SPTSavedTrack *i in mlist.items) {
                [controller2.myMusic addObject:i.uri];
            }
            if (mlist.hasNextPage) [self nextSongsFrom:mlist];
            [controller2.player playURIs:controller2.myMusic fromIndex:0 callback:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"*** Starting playback got error: %@", error);
                    return;
                }
                [self itemChangeCallback];
                
            }];
            
        }];
        
    }];
}

- (void) itemChangeCallback {
    ALSpotifyManager *controller = [ALSpotifyManager defaultController];
    /* Next item callback
     * Update the song label, background and start playing.
     */

}


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
