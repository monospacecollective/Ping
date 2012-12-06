//
//  UCDWelcomePageAboutView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewAbout.h"
#import "UCDWelcomeButton.h"

@implementation UCDWelcomePageViewAbout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"Tell us a little about you:";
        self.subtitle.text = @"You can change what ping knows about you at any time from Ping’s “Settings” pane.";
        
        self.doneButton = [[UCDWelcomeButton alloc] init];
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:self.doneButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect doneButtonFrame = self.doneButton.frame;
    doneButtonFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.doneButton.frame) / 2.0));
    doneButtonFrame.origin.y = floorf((CGRectGetMinY(self.subtitle.frame) - (CGRectGetHeight(self.doneButton.frame) + 20.0)));
    self.doneButton.frame = doneButtonFrame;
}

@end
