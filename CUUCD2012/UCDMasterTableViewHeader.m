//
//  UCDMasterTableViewHeader.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterTableViewHeader.h"
#import "UCDStyleManager.h"

@interface UCDMasterTableViewHeader ()

@property (nonatomic, strong) UIView *topShadowLine;
@property (nonatomic, strong) UIView *topHighlightLine;
@property (nonatomic, strong) UIView *bottomShadowLine;
@property (nonatomic, strong) CAGradientLayer *gradient;

@end

@implementation UCDMasterTableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.gradient = [CAGradientLayer layer];
        UIColor *gradientTopColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        UIColor *gradientBottomColor = [UIColor colorWithWhite:0.05 alpha:1.0];
        self.gradient.colors = @[(id)[gradientTopColor CGColor], (id)[gradientBottomColor CGColor]];
        [self.layer insertSublayer:self.gradient atIndex:0];
        
        self.title = [[UILabel alloc] init];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [[UCDStyleManager sharedManager] boldFontOfSize:12.0];
        self.title.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        self.title.shadowColor = [UIColor blackColor];
        self.title.shadowOffset = CGSizeMake(0.0, -1.0);
        [self addSubview:self.title];
        
        self.topHighlightLine = [[UIView alloc] init];
        self.topHighlightLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.075];
        [self addSubview:self.topHighlightLine];
        
        self.bottomShadowLine = [[UIView alloc] init];
        self.bottomShadowLine.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bottomShadowLine];
        
        self.topShadowLine = [[UIView alloc] init];
        self.topShadowLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.topShadowLine];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradient.frame = self.bounds;
    
    CGFloat labelHorizontalInset = 10.0;
    self.title.frame = CGRectMake(labelHorizontalInset, 0.0, (CGRectGetWidth(self.frame) - (labelHorizontalInset * 2.0)), CGRectGetHeight(self.frame));
    
    self.bottomShadowLine.frame = CGRectMake(0.0, (CGRectGetHeight(self.frame) - 1.0), self.frame.size.width, 1.0);
    self.topShadowLine.frame = CGRectMake(0.0, -1.0, CGRectGetWidth(self.frame), 1.0);
    self.topHighlightLine.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), 1.0);
}

@end
