//
//  UCDPlaceCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlaceCell.h"

//#define LAYOUT_DEBUG

@interface UCDPlaceCell ()

@end

@implementation UCDPlaceCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.distanceLabel sizeToFit];
    CGRect distanceLabelFrame = self.distanceLabel.frame;
    distanceLabelFrame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(self.distanceLabel.frame) - 10.0;
    distanceLabelFrame.origin.y = ceilf((CGRectGetHeight(self.frame) / 2.0) - (CGRectGetHeight(self.distanceLabel.frame) / 2.0));
    self.distanceLabel.frame = distanceLabelFrame;
    
    CGFloat contentPadding = 6.0;
    CGRect textLabelFrame = self.textLabel.frame;
    if ((CGRectGetMinX(textLabelFrame) + CGRectGetWidth(textLabelFrame)) > (CGRectGetMinX(self.distanceLabel.frame) - contentPadding)) {
        textLabelFrame.size.width = CGRectGetMinX(self.distanceLabel.frame) - contentPadding - CGRectGetMinX(textLabelFrame);
    }
    self.textLabel.frame = textLabelFrame;
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    if ((CGRectGetMinX(detailTextLabelFrame) + CGRectGetWidth(detailTextLabelFrame)) > (CGRectGetMinX(self.distanceLabel.frame) - contentPadding)) {
        detailTextLabelFrame.size.width = CGRectGetMinX(self.distanceLabel.frame) - contentPadding - CGRectGetMinX(detailTextLabelFrame);
    }
    self.detailTextLabel.frame = detailTextLabelFrame;
    
#if defined(LAYOUT_DEBUG)
    self.textLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.detailTextLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.distanceLabel = [[UCDBorderedLabel alloc] init];
        self.distanceLabel.font = [UIFont fontWithName:@"Gotham HTF Book" size:12.0];
        self.distanceLabel.borderColor = [UIColor colorWithRed:0.56 green:0.24 blue:0.24 alpha:1.0];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.shouldFill = YES;
        self.distanceLabel.textEdgeInsets = UIEdgeInsetsMake(1.0, 2.0, 2.0, 2.0);
        [self.contentView addSubview:self.distanceLabel];
        
        self.textLabel.font = [UIFont fontWithName:@"Gotham HTF" size:17.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Gotham HTF Book" size:13.0];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.shadowColor = [UIColor whiteColor];
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
