//
//  ALAlarmManager.h
//  alarmify
//
//  Created by Daniel Distant on 1/29/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ALAlarmManager : NSObject<NSCoding>

@property NSMutableArray *alarms;

@property NSTimer *countdownTimer;

@property(nonatomic) NSString *label;
@property(nonatomic) NSDate *timeToSetOff;

@end
