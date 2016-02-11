//
//  ALAddAlarmTableViewController.h
//  Alarmify
//
//  Created by Charles Kang on 2/9/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALAddAlarmTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *alarmTimePicker;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSnooze;

@property (weak, nonatomic) IBOutlet UILabel *alarmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmFrequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmSoundNameLabel;

@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;



@end
