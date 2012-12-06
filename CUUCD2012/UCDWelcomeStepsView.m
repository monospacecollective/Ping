//
//  UCDWelcomeStepsView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomeStepsView.h"
#import "UCDWelcomeStepView.h"

NSUInteger const UCDWelcomeStepsViewStepsCount = 5;

@interface UCDWelcomeStepsView () {
    NSUInteger _visibleSteps;
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSArray *stepViews;

- (void)updateStepVisiblity;

@end

@implementation UCDWelcomeStepsView

@dynamic visibleSteps;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    if (self) {
        
        self.visibleSteps = 0;
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UCDWelcomeStepsWell"]];
        [self addSubview:self.backgroundImageView];
        
        NSMutableArray *tempStepViews = [NSMutableArray arrayWithCapacity:UCDWelcomeStepsViewStepsCount];
        for (NSUInteger step = 0; step < UCDWelcomeStepsViewStepsCount; step++) {
            UCDWelcomeStepView *welcomeStepView = [[UCDWelcomeStepView alloc] init];
            [tempStepViews addObject:welcomeStepView];
            [self addSubview:welcomeStepView];
            welcomeStepView.stepLabel.text = [NSString stringWithFormat:@"%d", (step + 1)];
        }
        self.stepViews = [NSArray arrayWithArray:tempStepViews];
        [self updateStepVisiblity];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect workingRect = CGRectMake(2.0, 0.0, 44.0, 44.0);
    for (NSUInteger step = 0; step < UCDWelcomeStepsViewStepsCount; step++) {
        UCDWelcomeStepView *welcomeStepView = self.stepViews[step];
        welcomeStepView.frame = workingRect;
        workingRect = CGRectOffset(workingRect, (workingRect.size.width + 24.0), 0.0);
        welcomeStepView.alpha = (step >= self.visibleSteps) ? 0.0 : 1.0;
    }
}

#pragma mark - UCDWelcomeStepsView

- (void)updateStepVisiblity
{
    for (NSUInteger step = 0; step < UCDWelcomeStepsViewStepsCount; step++) {
        UCDWelcomeStepView *welcomeStepView = self.stepViews[step];
        welcomeStepView.alpha = (step >= self.visibleSteps) ? 0.0 : 1.0;
    }
}

- (void)setVisibleSteps:(NSUInteger)visibleSteps
{
    _visibleSteps = visibleSteps;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self updateStepVisiblity];
    }];
}

- (NSUInteger)visibleSteps
{
    return _visibleSteps;
}

@end
