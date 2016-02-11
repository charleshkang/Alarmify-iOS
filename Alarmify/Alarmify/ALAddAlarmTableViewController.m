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

- (IBAction)snoozeButtonTapped:(id)sender {
    NSLog(@"snooze toggled!");
}
- (IBAction)saveNewAlarmButtonTapped:(id)sender {
    NSLog(@"new alarm saved!");
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
