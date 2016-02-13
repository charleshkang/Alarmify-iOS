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

@end

@implementation ALAddAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    ALAlarmManager *oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];

}

- (IBAction)snoozeButtonTapped:(id)sender {
    NSLog(@"snooze toggled!");
}
- (IBAction)saveNewAlarmButtonTapped:(id)sender {
    NSLog(@"new alarm saved!");
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
