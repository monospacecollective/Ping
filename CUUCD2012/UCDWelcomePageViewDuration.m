//
//  UCDWelcomePageViewAccuracy.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewDuration.h"
#import "UCDWelcomeButton.h"

@interface UCDWelcomePageViewDuration ()

@property (nonatomic, strong) UIImageView *durationIcon;
@property (nonatomic, strong) NSArray *durationButonArray;

@end

@implementation UCDWelcomePageViewDuration

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"Ping will collect your location data at an interval of your choice:";
        self.subtitle.text = @"You can change this settings at any time from Ping’s “Settings” pane.";
        
        self.durationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UCDWelcomePageDurationIcon"]];
        [self addSubview:self.durationIcon];
        
        __weak typeof(self) blockSelf = self;
        
        NSMutableArray *durationButonArray = [NSMutableArray array];
        
        NSArray *durationTitles = @[@"1m", @"15m", @"30m", @"1h"];
        NSArray *durations = @[
            @(UCDWelcomePageViewDurationIntervalMinute),
            @(UCDWelcomePageViewDurationIntervalFiveMinutes),
            @(UCDWelcomePageViewDurationIntervalThirtyMinutes),
            @(UCDWelcomePageViewDurationIntervalHour),
        ];
        
        for (NSUInteger durationButtonIndex = 0; durationButtonIndex < 4; durationButtonIndex++) {
            UCDWelcomeButton *durationButton = [[UCDWelcomeButton alloc] init];
            durationButton.frame = CGRectInset(durationButton.frame, 56.0, 0.0);
            [durationButton setTitle:durationTitles[durationButtonIndex] forState:UIControlStateNormal];
            [durationButton addEventHandler:^{
                if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(welcomePageViewDuration:didSelectDuration:)]) {
                    [blockSelf.delegate welcomePageViewDuration:blockSelf didSelectDuration:[durations[durationButtonIndex] integerValue]];
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:durationButton];
            [durationButonArray addObject:durationButton];
        }
        self.durationButonArray =  durationButonArray;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect durationIconFrame = self.durationIcon.frame;
    durationIconFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.durationIcon.frame) / 2.0));
    durationIconFrame.origin.y = CGRectGetMaxY(self.title.frame) + 24.0;
    self.durationIcon.frame = durationIconFrame;
 
    CGFloat buttonsY = floorf((CGRectGetMaxY(self.durationIcon.frame) + ((CGRectGetMinY(self.subtitle.frame) - CGRectGetMaxY(self.durationIcon.frame)) / 2.0)) - (CGRectGetHeight([self.durationButonArray[0] frame]) / 2.0));
    CGRect workingRect = CGRectMake(CGRectGetMinX(self.title.frame), buttonsY, CGRectGetWidth([self.durationButonArray[0] frame]), CGRectGetHeight([self.durationButonArray[0] frame]));
    
    for (NSUInteger durationButtonIndex = 0; durationButtonIndex < 4; durationButtonIndex++) {
        UCDWelcomeButton *durationButton = self.durationButonArray[durationButtonIndex];
        durationButton.frame = workingRect;
        workingRect = CGRectOffset(workingRect, (CGRectGetWidth(workingRect) + 9.0), 0.0);
    }
}

@end
