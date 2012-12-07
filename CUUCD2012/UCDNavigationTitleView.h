//
//  UCDNavigationTitleView.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UCDNavigationTitleViewAnimationDirection) {
    UCDNavigationTitleViewAnimationDirectionLeft,
    UCDNavigationTitleViewAnimationDirectionRight,
};

@interface UCDNavigationTitleView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setSubtitleText:(NSString *)text animated:(BOOL)animated direction:(UCDNavigationTitleViewAnimationDirection)direction;

@end
