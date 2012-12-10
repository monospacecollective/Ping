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
    distanceLabelFrame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(self.distanceLabel.frame) - 8.0;
    distanceLabelFrame.origin.y = ceilf((CGRectGetHeight(self.frame) / 2.0) - (CGRectGetHeight(self.distanceLabel.frame) / 2.0));
    self.distanceLabel.frame = distanceLabelFrame;
    
    CGFloat popularityViewPadding = 8.0;
    CGRect popularityViewFrame = self.popularityView.frame;
    popularityViewFrame.origin.x = popularityViewPadding;
    popularityViewFrame.origin.y = floorf((CGRectGetHeight(self.frame) / 2.0) - (CGRectGetHeight(self.popularityView.frame) / 2.0));
    self.popularityView.frame = popularityViewFrame;
    
    CGFloat textLabelX = (CGRectGetMaxX(self.popularityView.frame) + popularityViewPadding);
    
    CGFloat contentPadding = 6.0;
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = textLabelX;
    if ((CGRectGetMinX(textLabelFrame) + CGRectGetWidth(textLabelFrame)) > (CGRectGetMinX(self.distanceLabel.frame) - contentPadding)) {
        textLabelFrame.size.width = CGRectGetMinX(self.distanceLabel.frame) - contentPadding - CGRectGetMinX(textLabelFrame);
    }
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = textLabelX;
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
        self.distanceLabel.borderShadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.distanceLabel.shouldFill = YES;
        self.distanceLabel.textEdgeInsets = UIEdgeInsetsMake(1.0, 2.0, 2.0, 2.0);
        [self.contentView addSubview:self.distanceLabel];
        
        self.popularityView = [[UCDPopularityView alloc] init];
        self.popularityView.fillView.backgroundColor = [UIColor colorWithRed:0.56 green:0.24 blue:0.24 alpha:1.0];
        [self addSubview:self.popularityView];
    }
    return self;
}

@end
