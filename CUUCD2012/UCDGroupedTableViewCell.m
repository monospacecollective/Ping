//
//  UCDGroupedTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewCell.h"

@implementation UCDGroupedTableViewCell

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont fontWithName:@"Gotham HTF" size:17.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Gotham HTF Book" size:17.0];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.shadowColor = [UIColor whiteColor];
        self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
        [super setHighlighted:highlighted animated:animated];
        if (highlighted) {
            self.backgroundView.alpha = 1.0;
            self.textLabel.shadowColor = [UIColor lightGrayColor];
            self.detailTextLabel.shadowColor = [UIColor lightGrayColor];
            self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
            self.detailTextLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        } else {
            self.backgroundView.alpha = 0.75;
            self.textLabel.shadowColor = [UIColor whiteColor];
            self.detailTextLabel.shadowColor = [UIColor whiteColor];
            self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        }
    }
}

@end
