//
//  ALLabelViewController.m
//  Alarmify
//
//  Created by Daniel Distant on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALLabelViewController.h"

@interface ALLabelViewController ()

<UITextFieldDelegate,
LabelDelegate>

@end

@implementation ALLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.alarmTextField.delegate = self;
}

-(void)didSetLabel:(NSString *)label
{
    [self.delegate didSetLabel:label];
}


#pragma mark - Text field delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didSetLabel:textField.text];
    
    [self textFieldDidEndEditing:textField];
    
    return YES;
}


#pragma mark - Navigation



/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
