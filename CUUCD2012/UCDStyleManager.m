//
//  UCDStyleManager.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDStyleManager.h"

static UCDStyleManager *singletonInstance = nil;

@implementation UCDStyleManager

+ (UCDStyleManager *)sharedManager
{
    if (!singletonInstance) {
        singletonInstance = [[[self class] alloc] init];
    }
    return singletonInstance;
}

// Toolbar
- (void)styleToolbar:(UIToolbar *)toolbar
{
    [toolbar setBackgroundImage:[UIImage imageNamed:@"UCDFooterBackground"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolbar sizeToFit];
}

// Navigation Controller
- (void)styleNavigationController:(UINavigationController *)navigationController
{
    UINavigationBar *navigationBar = [navigationController navigationBar];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"UCDHeaderBackground"] forBarMetrics:UIBarMetricsDefault];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationBar.titleTextAttributes = @{
        UITextAttributeTextColor : [UIColor whiteColor],
        UITextAttributeTextShadowColor : [UIColor blackColor],
        UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)]
        };
    }
    
    navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - Bar Button

- (UIButton *)backButtonWithTitle:(NSString*)title
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Gotham HTF" size:12.0];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeLeft;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(8.0, 15.0, 7.0, 10.0);
    [button sizeToFit];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"UCDBarButtonBackgroundBack.png"]
                                stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    UIImage *backButtonImagePressed = [[UIImage imageNamed:@"UCDBarButtonBackgroundBackPressed.png"]
                                       stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
    [button setBackgroundImage:backButtonImagePressed forState:UIControlStateHighlighted];
    
    return button;
}

- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString*)title action:(void(^)(void))handler
{
    UIButton *button = [self backButtonWithTitle:title];
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
