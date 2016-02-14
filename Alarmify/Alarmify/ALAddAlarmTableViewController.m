//
//  ALAddAlarmTableViewController.m
//  Alarmify
//
//  Created by Charles Kang on 2/9/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALAddAlarmTableViewController.h"
#import "ALSoundPickerViewController.h"
#import "ALAlarm.h"
#import "ALAlarmManager.h"
#import "ALSpotifyManager.h"

@interface ALAddAlarmTableViewController ()

@property (nonatomic) NSMutableArray *alarmElements;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmPicker;

@end

@implementation ALAddAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Not sure if you'll need this Eric/Dan
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
//    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
//    ALAlarmManager *oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];

}

- (IBAction)snoozeButtonTapped:(id)sender {
    NSLog(@"snooze toggled!");
}
- (IBAction)saveNewAlarmButtonTapped:(id)sender {
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
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"select_playlist"]) {
//        ALSoundPickerViewController *songSelection = (ALSoundPickerViewController *)segue.destinationViewController;
//        songSelection.modalPresentationStyle = UIModalPresentationCurrentContext;
//        ALSpotifyManager *controller = [ALSpotifyManager defaultController];
//        songSelection.playlists = controller.playlists.items;
//        songSelection.selected = @0;
//    }
//}

@end
