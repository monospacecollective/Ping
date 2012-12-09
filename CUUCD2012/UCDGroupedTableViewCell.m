//
//  UCDGroupedTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewCell.h"

@interface UCDGroupedTableViewCell ()

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated;

@end

@implementation UCDGroupedTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.alpha = 0.75;
}

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
        [self updateBackgroundState:highlighted animated:animated];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
        [super setSelected:selected animated:animated];
        [self updateBackgroundState:selected animated:animated];
    }
}

#pragma mark - UCDGroupedTableViewCell

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    void(^updateBackgroundState)() = ^() {
        if (darkened) {
            self.textLabel.shadowColor = [UIColor lightGrayColor];
            self.detailTextLabel.shadowColor = [UIColor lightGrayColor];
            self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
            self.detailTextLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        } else {
            self.textLabel.shadowColor = [UIColor whiteColor];
            self.detailTextLabel.shadowColor = [UIColor whiteColor];
            self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:updateBackgroundState];
    } else {
        updateBackgroundState();
    }
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

@end
