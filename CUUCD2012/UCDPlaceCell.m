//
//  UCDPlaceCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlaceCell.h"

@implementation UCDPlaceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.detailTextLabel.shadowColor = [UIColor whiteColor];
        
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
