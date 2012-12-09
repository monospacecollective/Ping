//
//  UCDButtonTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/8/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDButtonGroupedTableViewCell.h"

NSString * const UCDButtonReuseIdentifier = @"ButtonReuseIdentifier";

@implementation UCDButtonGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
