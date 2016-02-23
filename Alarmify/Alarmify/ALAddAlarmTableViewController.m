//
//  ALAddAlarmTableViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/9/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALAddAlarmTableViewController.h"
#import "ALAlarm.h"
#import "ALAlarmManager.h"
#import "ALSpotifyManager.h"

#import "ALPlaylistsViewController.h"

#import "ALLabelViewController.h"


@protocol LabelDelegate <NSObject>

- (void) didSetLabel:(NSString *)label;

@end

@interface ALAddAlarmTableViewController () <LabelDelegate>

@property (nonatomic) NSMutableArray *alarmElements;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmPicker;

@end



@implementation ALAddAlarmTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Not sure if you'll need this Eric/Dan
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    //    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    //    ALAlarmManager *oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];
    
}

- (IBAction)snoozeButtonTapped:(id)sender
{
    NSLog(@"snooze toggled!");
}

- (IBAction)saveNewAlarmButtonTapped:(id)sender
{
    
    //instantiate a new alarm object
    
    ALAlarm *newAlarm = [[ALAlarm alloc] init];
    
    NSDate *userEnteredDate = self.alarmPicker.date;
    NSDate *now = [NSDate date];
    
    if (now >= userEnteredDate) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|255 fromDate:userEnteredDate];  // 255= the important component masks or'd together
        [components setSecond:0];
        components.day += 1;
        userEnteredDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    //    NSCalendar *cal = [NSCalendar currentCalendar];
    //    NSDateComponents *comp = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
    //                                    fromDate:now];
    //    [comp setHour:alarmHour];
    //    [comp setMinute:alarmMinute];
    //    NSDate *alarm = [cal dateFromComponents:comp];
    //
    //    // If alarm <= now ...
    //    if ([alarm compare:now] != NSOrderedDescending) {
    //        // ... add one day:
    //        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    //        [oneDay setDay:1];
    //        alarm = [cal dateByAddingComponents:oneDay toDate:alarm options:0];
    //    }
    
    
    NSLog(@"new alarm saved!");
    NSLog(@"%@", now);
    NSLog(@"%@", userEnteredDate);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//change this name later, we will pass back more data with these methods

#pragma mark -- LabelDelegate methods

- (void)didSetLabel:(NSString *)label
{
    NSLog(@"the delegate works");
}

#pragma mark -- Table View methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"playlists"]) {
//        ALPlaylistsViewController *songSelection = (ALPlaylistsViewController *)segue.destinationViewController;
//
//        
//        NSLog(@"View did segue");
//    }
    
    if ([segue.identifier isEqualToString:@"labelSegue"]) {
        ALLabelViewController *labelViewController = segue.destinationViewController;
        labelViewController.delegate = self;
    }
}

@end
