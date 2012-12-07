//
//  UCDNavigationTitleView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDNavigationTitleView.h"

@interface UCDNavigationTitleView ()

@property (nonatomic, assign) BOOL animatingSubtitle;

@end

//#define LAYOUT_DEBUG

@implementation UCDNavigationTitleView

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.title.text = title;
        self.subtitle.text = subtitle;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 180.0, 40.0)];
    if (self) {
        
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont fontWithName:@"Gotham HTF" size:20.0];
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] init];
        self.subtitle.font = [UIFont fontWithName:@"Gotham HTF Book" size:13.0];
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.textAlignment = NSTextAlignmentCenter;
        self.subtitle.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.subtitle];
        
        self.title.backgroundColor = [UIColor clearColor];
        self.subtitle.backgroundColor = [UIColor clearColor];
        
#if defined(LAYOUT_DEBUG)
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        self.title.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.subtitle.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize titleSize = [self.title.text sizeWithFont:self.title.font];
    CGRect tempTitleFrame = self.title.frame;
    tempTitleFrame.size.height = titleSize.height;
    tempTitleFrame.size.width = CGRectGetWidth(self.frame);
    self.title.frame = tempTitleFrame;

    if (!self.animatingSubtitle) {
        CGSize subtitleSize = [self.subtitle.text sizeWithFont:self.subtitle.font];
        CGRect tempSubtitleFrame = self.subtitle.frame;
        tempSubtitleFrame.origin.y = CGRectGetMaxY(self.title.frame);
        tempSubtitleFrame.size.height = subtitleSize.height;
        tempSubtitleFrame.size.width = CGRectGetWidth(self.frame);
        self.subtitle.frame = tempSubtitleFrame;
    }
}

#pragma mark - UCDNavigationTitleView

- (void)setSubtitleText:(NSString *)text animated:(BOOL)animated direction:(UCDNavigationTitleViewAnimationDirection)direction;
{
    if (animated == NO || self.animatingSubtitle) {
        self.subtitle.text = text;
    }
    
    self.animatingSubtitle = YES;
    
    UILabel *previousSubtitle = self.subtitle;
    CGRect subtitleFrame = self.subtitle.frame;
    CGFloat offset = ((direction == UCDNavigationTitleViewAnimationDirectionLeft) ? CGRectGetWidth(self.frame) : -CGRectGetWidth(self.frame));
    offset /= 2.0;
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectOffset(subtitleFrame, offset, 0.0)];
    self.subtitle.font = [UIFont fontWithName:@"Gotham HTF Book" size:13.0];
    self.subtitle.textColor = [UIColor whiteColor];
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.subtitle.text = text;
    self.subtitle.backgroundColor = [UIColor clearColor];
    self.subtitle.alpha = 0.0;
    [self addSubview:self.subtitle];
    
    [UIView animateWithDuration:0.3 animations:^{
        previousSubtitle.alpha = 0.0;
        previousSubtitle.frame = CGRectOffset(subtitleFrame, -offset, 0.0);
        self.subtitle.frame = CGRectOffset(self.subtitle.frame, -offset, 0.0);
        self.subtitle.alpha = 1.0;
    } completion:^(BOOL finished) {
        [previousSubtitle removeFromSuperview];
        self.animatingSubtitle = NO;
    }];
}

@end
