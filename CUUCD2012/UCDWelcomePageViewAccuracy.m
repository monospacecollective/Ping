//
//  UCDWelcomePageViewAccuracy.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewAccuracy.h"
#import "UCDWelcomeButton.h"

@interface UCDWelcomePageViewAccuracy ()

@property (nonatomic, strong) UIImageView *accuracyIcon;
@property (nonatomic, strong) NSArray *accuracyButonArray;

@end

@implementation UCDWelcomePageViewAccuracy

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"Ping will collect your location data at an accuracy of your choice:";
        self.subtitle.text = @"You can change this settings at any time from Ping’s “Settings” pane.";
        
        self.accuracyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UCDWelcomePageAccuracyIcon"]];
        [self addSubview:self.accuracyIcon];
        
        __weak typeof(self) blockSelf = self;
        
        NSMutableArray *accuracyButonArray = [NSMutableArray array];
        
        NSArray *accuracyTitles = @[@"10m", @"50m", @".5km", @"1km"];
        NSArray *accuracys = @[
            @(UCDUserAccuracyIntervalTenMeters),
            @(UCDUserAccuracyIntervalFiftyMeters),
            @(UCDUserAccuracyIntervalFiveHundredMeters),
            @(UCDUserAccuracyIntervalOneKilometer),
        ];
        
        for (NSUInteger accuracyButtonIndex = 0; accuracyButtonIndex < 4; accuracyButtonIndex++) {
            UCDWelcomeButton *accuracyButton = [[UCDWelcomeButton alloc] init];
            accuracyButton.frame = CGRectInset(accuracyButton.frame, 56.0, 0.0);
            [accuracyButton setTitle:accuracyTitles[accuracyButtonIndex] forState:UIControlStateNormal];
            [accuracyButton addEventHandler:^{
                if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(welcomePageViewAccuracy:didSelectAccuracy:)]) {
                    [blockSelf.delegate welcomePageViewAccuracy:blockSelf didSelectAccuracy:[accuracys[accuracyButtonIndex] integerValue]];
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:accuracyButton];
            [accuracyButonArray addObject:accuracyButton];
        }
        self.accuracyButonArray =  accuracyButonArray;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect accuracyIconFrame = self.accuracyIcon.frame;
    accuracyIconFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.accuracyIcon.frame) / 2.0));
    accuracyIconFrame.origin.y = CGRectGetMaxY(self.title.frame) + 24.0;
    self.accuracyIcon.frame = accuracyIconFrame;
 
    CGFloat buttonsY = floorf((CGRectGetMaxY(self.accuracyIcon.frame) + ((CGRectGetMinY(self.subtitle.frame) - CGRectGetMaxY(self.accuracyIcon.frame)) / 2.0)) - (CGRectGetHeight([self.accuracyButonArray[0] frame]) / 2.0));
    CGRect workingRect = CGRectMake(CGRectGetMinX(self.title.frame), buttonsY, CGRectGetWidth([self.accuracyButonArray[0] frame]), CGRectGetHeight([self.accuracyButonArray[0] frame]));
    
    for (NSUInteger accuracyButtonIndex = 0; accuracyButtonIndex < 4; accuracyButtonIndex++) {
        UCDWelcomeButton *accuracyButton = self.accuracyButonArray[accuracyButtonIndex];
        accuracyButton.frame = workingRect;
        workingRect = CGRectOffset(workingRect, (CGRectGetWidth(workingRect) + 9.0), 0.0);
    }
}

@end
