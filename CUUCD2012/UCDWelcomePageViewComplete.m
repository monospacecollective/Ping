//
//  UCDWelcomePageCompleteView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewComplete.h"
#import "UCDButton.h"

@implementation UCDWelcomePageViewComplete

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"You're ready to get started with Ping.\n\nWe hope you'll find Ping useful. Just by sharing your location you're making Ping better for everyone!";
        self.subtitle.text = @"We'd love to hear what you have to say about Ping. Don't hesitate to contact us with your feedback!";
        
        self.completeButton = [[UCDButton alloc] init];
        [self.completeButton setTitle:@"Get Started!" forState:UIControlStateNormal];
        [self addSubview:self.completeButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect completeButtonFrame = self.completeButton.frame;
    completeButtonFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.completeButton.frame) / 2.0));
    completeButtonFrame.origin.y = floorf((CGRectGetMaxY(self.title.frame) + ((CGRectGetMinY(self.subtitle.frame) - CGRectGetMaxY(self.title.frame)) / 2.0)) - (CGRectGetHeight(self.completeButton.frame) / 2.0));
    self.completeButton.frame = completeButtonFrame;
}

@end
