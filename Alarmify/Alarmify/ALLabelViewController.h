//
//  ALLabelViewController.h
//  Alarmify
//
//  Created by Daniel Distant on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LabelDelegate <NSObject>

- (void) didSetLabel:(NSString *)label;

@end

@interface ALLabelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *alarmTextField;

@property (weak, nonatomic) id<LabelDelegate>delegate; //passes alarm name back to the ALAddAlarmVC

@end
