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

@interface ALAddAlarmTableViewController ()

@property (nonatomic) NSMutableArray *alarmElements;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmPicker;

@end

@implementation ALAddAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    ALAlarmManager *oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
// this is a commment
// another comment

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if(self.alarmNameLabel) {
        NSString *nameLabel = self.alarmElements[indexPath.row];
        
    }

}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    
//    if(self.showAllPokemon) {
//        NSString * pokemonName = self.allPokemonAlphabetized[indexPath.row];
//        PokemonDetailViewController *vc = segue.destinationViewController;
//        
//        vc.pokemonName = pokemonName;
//    }
//    
//    else {
//        
//        
//        NSArray * keys = [self.allPokemon allKeys];
//        NSString *key = keys[indexPath.section];
//        NSArray * pokemonArray = [self.allPokemon objectForKey:key];
//        NSString * pokemonName = pokemonArray[indexPath.row];
//        PokemonDetailViewController *vc = segue.destinationViewController;
//        
//        vc.pokemonName = pokemonName;
//    }
//    
//}

@end
