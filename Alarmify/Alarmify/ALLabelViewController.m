//
//  ALLabelViewController.m
//  Alarmify
//
//  Created by Daniel Distant on 2/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "ALLabelViewController.h"

@interface ALLabelViewController ()

<UITextFieldDelegate>

@end

@implementation ALLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alarmTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) labelFinished {
    
}

#pragma mark - Text field delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self textFieldDidEndEditing:textField];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
