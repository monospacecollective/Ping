//
//  UCDMasterTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterTableViewCell.h"

NSString * const UCDMasterCellReuseIdentifier = @"MasterCellReuseIdentifier";

@implementation UCDMasterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.shadowColor = [UIColor blackColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    return self;
}

@end
