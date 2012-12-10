//
//  UCDStyleManager.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDStyleManager.h"
#import "UIImage+Darken.h"

static UCDStyleManager *singletonInstance = nil;

@implementation UCDStyleManager

+ (UCDStyleManager *)sharedManager
{
    if (!singletonInstance) {
        singletonInstance = [[[self class] alloc] init];
    }
    return singletonInstance;
}

#pragma mark - Fonts

- (UIFont *)fontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham HTF Book" size:size];
}

- (UIFont *)boldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham HTF" size:size];
}

- (UIFont *)symbolSetFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SS Standard" size:size];    
}

#pragma mark - Toolbar

- (void)styleToolbar:(UIToolbar *)toolbar
{
    [toolbar setBackgroundImage:[UIImage imageNamed:@"UCDFooterBackground"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolbar sizeToFit];
}

#pragma mark -  Navigation Controller

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

- (UIButton *)barButtonCustomView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIEdgeInsets buttonBackgroundImageCapInsets = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0);
    [button setBackgroundImage:[[UIImage imageNamed:@"UCDBarButtonBackground"] resizableImageWithCapInsets:buttonBackgroundImageCapInsets] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"UCDBarButtonBackgroundPressed"] resizableImageWithCapInsets:buttonBackgroundImageCapInsets] forState:UIControlStateHighlighted];
    return button;
}

- (UIButton *)barButtonWithTitle:(NSString*)title
{
    UIButton* button = [self barButtonCustomView];
    
    button.titleLabel.font = [UIFont fontWithName:@"Gotham HTF" size:12.0];
    button.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeCenter;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0);
    [button sizeToFit];
    
    return button;
}

- (UIButton *)texturedButtonWithImage:(UIImage*)image
{
    UIButton* button = [self barButtonCustomView];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[image darkenedImageWithOverlayAlpha:0.3] forState:UIControlStateSelected];
    
    button.contentMode = UIViewContentModeCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(4.0, 9.0, 4.0, 9.0);
    [button sizeToFit];
    
    return button;
}

- (UIButton *)buttonWithTitle:(NSString*)title
{
    UIButton* button = [self barButtonCustomView];
    button.adjustsImageWhenHighlighted = NO;
    
    button.titleLabel.font = [self fontOfSize:12.0];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeCenter;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0);
    [button sizeToFit];
    
    return button;
}

- (UIButton *)backButtonWithTitle:(NSString*)title
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [self fontOfSize:12.0];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeLeft;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(8.0, 15.0, 7.0, 10.0);
    [button sizeToFit];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"UCDBarButtonBackgroundBack.png"] stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    UIImage *backButtonImagePressed = [[UIImage imageNamed:@"UCDBarButtonBackgroundBackPressed.png"] stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
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

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString*)title action:(void(^)(void))handler
{
    UIButton *button = [self buttonWithTitle:title];
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

- (UIBarButtonItem *)barButtonItemWithSymbolSetTitle:(NSString*)title action:(void(^)(void))handler
{
    UIButton *button = [self buttonWithTitle:title];
    button.titleLabel.font = [[UCDStyleManager sharedManager] symbolSetFontOfSize:14.0];
    button.contentEdgeInsets = UIEdgeInsetsMake(6.0, 13.0, 0.0, 13.0);
    [button sizeToFit];
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage*)image action:(void(^)(void))handler
{
    UIButton *button = [self texturedButtonWithImage:image];
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

#pragma mark - Pull to Refresh

- (SSPullToRefreshView *)pullToRefreshViewWithScrollView:(UIScrollView *)scrollView
{
    SSPullToRefreshView *refreshView = [[SSPullToRefreshView alloc] initWithScrollView:scrollView delegate:nil];
    SSPullToRefreshSimpleContentView *defaultContentView = [[SSPullToRefreshSimpleContentView alloc] init];
    defaultContentView.statusLabel.font = [UIFont fontWithName:@"Gotham HTF" size:15.0];
    defaultContentView.statusLabel.textColor = [UIColor darkGrayColor];
    defaultContentView.statusLabel.shadowColor = [UIColor whiteColor];
    defaultContentView.statusLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    refreshView.contentView = defaultContentView;
    return refreshView;
}

#pragma mark - Button

- (UIButton *)disclosureButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImage *disclosureIcon = [UIImage imageNamed:@"UCDDisclosureIcon"];
    [button setImage:disclosureIcon forState:UIControlStateNormal];
    [button setImage:[disclosureIcon darkenedImageWithOverlayAlpha:0.3] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0.0, 0.0, disclosureIcon.size.width, disclosureIcon.size.height)];
    return button;
}

#pragma mark - Popularity View

- (UCDPopularityView *)calloutPopularityView
{
    UCDPopularityView *popularityView = [[UCDPopularityView alloc] init];
    popularityView.fillView.backgroundColor = [UIColor colorWithRed:0.56 green:0.24 blue:0.24 alpha:1.0];
    popularityView.borderView.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.7] CGColor];
    popularityView.borderView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor];
    popularityView.borderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    popularityView.borderView.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    popularityView.fillView.layer.borderWidth = 0.0;
    popularityView.fillView.layer.shadowColor = [[UIColor colorWithRed:0.65 green:0.30 blue:0.30 alpha:1.0] CGColor];
    popularityView.fillView.layer.shadowOpacity = 1.0;
    popularityView.fillView.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    popularityView.fillView.layer.shadowRadius = 0.0;
    return popularityView;
}

@end
