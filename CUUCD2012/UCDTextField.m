//
//  UCDTextField.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/8/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDTextField.h"

static CGFloat UCDTextFieldHorizontalInset = 12.0;
static CGFloat UCDTextFieldVerticalInset = 9.0;

@interface UCDTextField ()

- (CGRect)textRectForBounds:(CGRect)bounds;

@end

@implementation UCDTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.0];
        self.layer.borderColor = [[UIColor colorWithWhite:0.0 alpha:0.2] CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.7] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.layer.shadowRadius = 0.0;
        self.layer.masksToBounds = NO;
        self.font = [UIFont fontWithName:@"Gotham HTF Book" size:17.0];
        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor grayColor] setFill];
    [self.placeholder drawInRect:rect withFont:[self font]];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, UCDTextFieldHorizontalInset, UCDTextFieldVerticalInset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, UCDTextFieldHorizontalInset, UCDTextFieldVerticalInset);
}

@end
