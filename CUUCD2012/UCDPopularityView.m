//
//  UCDPopularityView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPopularityView.h"

@interface UCDPopularityView ()

@end

@implementation UCDPopularityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 10.0, 30.0)];
    if (self) {
        
        self.fill = 0.0;
        
        self.borderView = [[UIView alloc] init];
        self.borderView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.borderView.layer.borderWidth = 1.0;
        self.borderView.layer.shadowColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor];
        self.borderView.layer.shadowOpacity = 1.0;
        self.borderView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.borderView.layer.shadowRadius = 0.0;
        [self addSubview:self.borderView];
        
        self.fillView = [[UIView alloc] init];
        self.fillView.backgroundColor = [UIColor redColor];
        self.fillView.layer.borderWidth = 1.0;
        self.fillView.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.25] CGColor];
        [self addSubview:self.fillView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.borderView.frame = self.bounds;
    
    CGRect fillViewFrame = CGRectInset(self.borderView.frame, 1.0, 1.0);
    fillViewFrame.size.height = floorf((self.fill / 1.0) * fillViewFrame.size.height);
    fillViewFrame.origin.y = (CGRectGetMaxY(self.borderView.frame) - 1.0) - CGRectGetHeight(fillViewFrame);
    self.fillView.frame = fillViewFrame;
}

#pragma mark - UCDPopularityView

- (void)setFill:(CGFloat)fill
{
    _fill = fill;
    [self setNeedsLayout];
}

@end
