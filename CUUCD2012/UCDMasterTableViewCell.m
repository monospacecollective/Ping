//
//  UCDMasterTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterTableViewCell.h"
#import "UCDStyleManager.h"

NSString * const UCDMasterCellReuseIdentifier = @"MasterCellReuseIdentifier";

@implementation UCDMasterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.shadowColor = [UIColor blackColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.iconLabel = [[UILabel alloc] init];
        self.iconLabel.backgroundColor = [UIColor clearColor];
        self.iconLabel.font = [[UCDStyleManager sharedManager] symbolSetFontOfSize:18.0];
        self.iconLabel.textColor = [UIColor whiteColor];
        self.iconLabel.shadowColor = [UIColor blackColor];
        self.iconLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:self.iconLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.iconLabel sizeToFit];
    CGRect iconLabelFrame = self.iconLabel.frame;
    iconLabelFrame.origin.x = 10.0;
    iconLabelFrame.origin.y = floorf((CGRectGetHeight(self.frame) / 2.0) - (CGRectGetHeight(iconLabelFrame) / 2.0)) + 3.0;
    self.iconLabel.frame = iconLabelFrame;
    
    [self.textLabel sizeToFit];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(iconLabelFrame) + 10.0;
    textLabelFrame.origin.y = floorf((CGRectGetHeight(self.frame) / 2.0) - (CGRectGetHeight(textLabelFrame) / 2.0));
    self.textLabel.frame = textLabelFrame;
}

@end
