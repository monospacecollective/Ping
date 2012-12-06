//
//  UCDWelcomeStepView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomeStepView.h"

//#define LAYOUT_DEBUG

@interface UCDWelcomeStepView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation UCDWelcomeStepView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UCDWelcomeStepBackground"]];
        [self addSubview:self.backgroundImageView];
        
        self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 9.0, 23.0, 20.0)];
        self.stepLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.stepLabel.textColor = [UIColor blackColor];
        self.stepLabel.textAlignment = NSTextAlignmentCenter;
        self.stepLabel.shadowColor = [UIColor whiteColor];
        self.stepLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.stepLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stepLabel];
        
#if defined(LAYOUT_DEBUG)
        self.stepLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.backgroundImageView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
#endif
    }
    return self;
}

@end
