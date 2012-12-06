//
//  UCDWelcomePageViewAccuracy.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageView.h"

@protocol UCDWelcomePageViewAccuracyDelegate;

typedef NS_ENUM(NSUInteger, UCDWelcomePageViewAccuracyInterval) {
    UCDWelcomePageViewAccuracyIntervalTenMeters = (10),
    UCDWelcomePageViewAccuracyIntervalFiftyMeters = (50),
    UCDWelcomePageViewAccuracyIntervalFiveHundredMeters = (500),
    UCDWelcomePageViewAccuracyIntervalOneKilometer = (1000),
};

@interface UCDWelcomePageViewAccuracy : UCDWelcomePageView

@property (nonatomic, assign) id<UCDWelcomePageViewAccuracyDelegate> delegate;

@end

@protocol  UCDWelcomePageViewAccuracyDelegate <NSObject>

- (void)welcomePageViewAccuracy:(UCDWelcomePageViewAccuracy *)pageView didSelectAccuracy:(UCDWelcomePageViewAccuracyInterval)accuracy;

@end
