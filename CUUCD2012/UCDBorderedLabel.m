//
//  UCDBorderedLabel.m
//  Erudio
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDBorderedLabel.h"

@implementation UCDBorderedLabel

@synthesize borderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		self.textEdgeInsets = UIEdgeInsetsZero;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.textEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 2.0, 0.0);
        self.borderShadowColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	}
	return self;
}

#pragma mark - UIView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize superSize = [super sizeThatFits:size];
    superSize.width += (12.0 + self.textEdgeInsets.left + self.textEdgeInsets.right);
    superSize.height += (7.0 + self.textEdgeInsets.top + self.textEdgeInsets.bottom);
    
    // Make sure that we're circular if the width is less than the height
    superSize.width = (superSize.width < superSize.height) ? (superSize.height - 2.0) : superSize.width;
    
    return superSize;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat verticalInset = (UIScreen.mainScreen.scale == 2.0) ? 2.5 : 2.0;
    CGRect borderPathRect = CGRectInset(rect, 2.0, verticalInset);
    borderPathRect = CGRectOffset(borderPathRect, 0, -.5);
    
    CGFloat borderRadius = floorf(CGRectGetHeight(self.frame) / 2.0);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(borderPathRect, 0.0, 1.0) cornerRadius:borderRadius];
    [self.borderShadowColor set];
    [shadowPath setLineWidth:1.0];
    [shadowPath stroke];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderPathRect cornerRadius:borderRadius];
    [self.borderColor set];
    if (self.shouldFill) {
        [borderPath fill];
        [borderPath stroke];
    } else {
        [borderPath setLineWidth:1.0];
        [borderPath stroke];
    }
    
    [super drawRect:rect];
}

#pragma mark - UILabel

- (void)drawTextInRect:(CGRect)rect {
    
	rect = UIEdgeInsetsInsetRect(rect, _textEdgeInsets);
	[super drawTextInRect:rect];
}

- (void)setTextEdgeInsets:(UIEdgeInsets)textEdgeInsets
{
	_textEdgeInsets = textEdgeInsets;
	[self setNeedsLayout];
}


@end
