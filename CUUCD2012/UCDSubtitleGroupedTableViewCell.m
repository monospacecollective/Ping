//
//  UCDSubtitleGroupedTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDSubtitleGroupedTableViewCell.h"
#import "UCDStyleManager.h"

NSString * const UCDSubtitleReuseIdentifier = @"SubtitleReuseIdentifier";

@implementation UCDSubtitleGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.font = [[UCDStyleManager sharedManager] fontOfSize:13.0];
    }
    return self;
}

@end
