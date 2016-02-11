//
//  ALAlarm.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ALAlarm : NSObject

@property NSTimer *timer;

@property NSTimer *snoozeTimer;

@property NSString *songName;

@property AVAudioPlayer *audioPlayer;

@property NSString *frequency;

@property BOOL isSnoozed;

@property BOOL willVibrate;

@property BOOL alarmWentOff;

@end
