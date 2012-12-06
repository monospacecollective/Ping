//
//  UCDWelcomePageViewAccuracy.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageView.h"

@protocol UCDWelcomePageViewDurationDelegate;

typedef NS_ENUM(NSUInteger, UCDWelcomePageViewDurationInterval) {
    UCDWelcomePageViewDurationIntervalMinute = (60),
    UCDWelcomePageViewDurationIntervalFiveMinutes = (5 * 60),
    UCDWelcomePageViewDurationIntervalThirtyMinutes = (30 * 60),
    UCDWelcomePageViewDurationIntervalHour = (60 * 60),
};

@interface UCDWelcomePageViewDuration : UCDWelcomePageView

@property (nonatomic, assign) id<UCDWelcomePageViewDurationDelegate> delegate;

@end

@protocol  UCDWelcomePageViewDurationDelegate <NSObject>

- (void)welcomePageViewDuration:(UCDWelcomePageViewDuration *)pageView didSelectDuration:(UCDWelcomePageViewDurationInterval)duration;

@end
