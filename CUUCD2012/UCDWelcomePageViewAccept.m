//
//  UCDWelcomePageAcceptView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewAccept.h"
#import "UCDButton.h"

@implementation UCDWelcomePageViewAccept

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"Ping is a service that anonymously collects information about your location.\n\nDo you agree to let Ping collect your location information?";
        self.subtitle.text = @"You can disable location sharing at any time from Ping’s “Settings” pane.";
        
        self.acceptButton = [[UCDButton alloc] init];
        [self.acceptButton setTitle:@"I Agree" forState:UIControlStateNormal];
        [self addSubview:self.acceptButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect acceptButtonFrame = self.acceptButton.frame;
    acceptButtonFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.acceptButton.frame) / 2.0));
    acceptButtonFrame.origin.y = floorf((CGRectGetMaxY(self.title.frame) + ((CGRectGetMinY(self.subtitle.frame) - CGRectGetMaxY(self.title.frame)) / 2.0)) - (CGRectGetHeight(self.acceptButton.frame) / 2.0));
    self.acceptButton.frame = acceptButtonFrame;
}

@end
