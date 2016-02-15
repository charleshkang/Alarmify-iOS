//
//  ALSignInViewController.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface ALSignInViewController : UIViewController
<NSURLConnectionDelegate,
SPTAuthViewDelegate>


- (BOOL)canHandleURL:(NSURL*)url;

- (void)handleAuthCallbackWithTriggeredAuthURL:(NSURL*)url;

@end
