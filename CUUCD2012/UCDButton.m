//
//  UCDWelcomeButton.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDButton.h"

@implementation UCDButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 175.0, 46.0)];
    if (self) {
        [self setBackgroundImage:[[UIImage imageNamed:@"UCDWelcomeButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0) resizingMode:UIImageResizingModeTile] forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:@"UCDWelcomeButtonBackgroundPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0) resizingMode:UIImageResizingModeTile] forState:UIControlStateHighlighted];
        
        self.titleLabel.font = [UIFont fontWithName:@"Gotham HTF" size:20.0];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        self.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    }
    return self;
}

@end
