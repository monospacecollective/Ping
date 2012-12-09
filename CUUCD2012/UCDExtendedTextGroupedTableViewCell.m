//
//  UCDExtendedTextGroupedTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDExtendedTextGroupedTableViewCell.h"
#import "UCDStyleManager.h"

NSString * const UCDExtendedTextReuseIdentifier = @"ExtendedTextReuseIdentifier";

@implementation UCDExtendedTextGroupedTableViewCell

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [[UCDStyleManager sharedManager] fontOfSize:15.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UCDExtendedTextGroupedTableViewCell

+ (CGFloat)cellHeightForText:(NSString *)text cellWidth:(CGFloat)width
{
    CGFloat minCellHeight = [self cellHeight];
    CGFloat cellHeight = ([text sizeWithFont:[[UCDStyleManager sharedManager] fontOfSize:15.0] constrainedToSize:CGSizeMake((width - 40.0), CGFLOAT_MAX)].height + 16.0);
    return (cellHeight < minCellHeight) ? minCellHeight : cellHeight;
}

@end
