//
//  PlaylistCell.m
//  Alarmify
//
//  Created by Charles Kang on 2/23/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "PlaylistCell.h"

@implementation PlaylistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    self.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:[UIFont systemFontSize]];
    return self;
}

@end
