//
//  UCDWelcomePageView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageView.h"

//#define LAYOUT_DEBUG

@implementation UCDWelcomePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont fontWithName:@"Gotham HTF Book" size:21.0];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.numberOfLines = 0;
        self.title.textColor = [UIColor blackColor];
        self.title.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.title.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] init];
        self.subtitle.font = [UIFont fontWithName:@"Gotham HTF Book" size:15.0];
        self.subtitle.textAlignment = NSTextAlignmentCenter;
        self.subtitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.subtitle.numberOfLines = 0;
        self.subtitle.textColor = [UIColor blackColor];
        self.subtitle.textAlignment = NSTextAlignmentCenter;
        self.subtitle.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.subtitle.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:self.subtitle];
        
        self.subtitle.backgroundColor = [UIColor clearColor];
        self.title.backgroundColor = [UIColor clearColor];
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        
#if defined(LAYOUT_DEBUG)
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        self.title.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.subtitle.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat inset = 20.0;
    CGFloat textWidth = (CGRectGetWidth(self.frame) - (inset * 2.0));
    
    CGSize titleSize = [self.title.text sizeWithFont:self.title.font constrainedToSize:CGSizeMake(textWidth, 300.0)];
    CGRect titleFrame = self.subtitle.frame;
    titleFrame.origin.x = inset;
    titleFrame.origin.y = inset;
    titleFrame.size = CGSizeMake(textWidth, titleSize.height);
    self.title.frame = titleFrame;
    
    CGSize subtitleSize = [self.subtitle.text sizeWithFont:self.subtitle.font constrainedToSize:CGSizeMake(textWidth, 200.0)];
    CGRect subtitleFrame = self.subtitle.frame;
    subtitleFrame.origin.x = inset;
    subtitleFrame.origin.y = (CGRectGetHeight(self.frame) - subtitleSize.height - inset);
    subtitleFrame.size = CGSizeMake(textWidth, subtitleSize.height);
    self.subtitle.frame = subtitleFrame;
}

@end
