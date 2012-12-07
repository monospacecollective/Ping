//
//  UCDWelcomePageViewAccuracy.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageView.h"
#import "UCDUser.h"

@protocol UCDWelcomePageViewAccuracyDelegate;

@interface UCDWelcomePageViewAccuracy : UCDWelcomePageView

@property (nonatomic, assign) id<UCDWelcomePageViewAccuracyDelegate> delegate;

@end

@protocol  UCDWelcomePageViewAccuracyDelegate <NSObject>

- (void)welcomePageViewAccuracy:(UCDWelcomePageViewAccuracy *)pageView didSelectAccuracy:(UCDUserAccuracyInterval)accuracy;

@end
