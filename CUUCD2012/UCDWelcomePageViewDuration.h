//
//  UCDWelcomePageViewAccuracy.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageView.h"
#import "UCDUser.h"

@protocol UCDWelcomePageViewDurationDelegate;

@interface UCDWelcomePageViewDuration : UCDWelcomePageView

@property (nonatomic, assign) id<UCDWelcomePageViewDurationDelegate> delegate;

@end

@protocol  UCDWelcomePageViewDurationDelegate <NSObject>

- (void)welcomePageViewDuration:(UCDWelcomePageViewDuration *)pageView didSelectDuration:(UCDUserDurationInterval)duration;

@end
