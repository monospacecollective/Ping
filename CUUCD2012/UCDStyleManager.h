//
//  UCDStyleManager.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCDStyleManager : NSObject

+ (UCDStyleManager *)sharedManager;

// Toolbar
- (void)styleToolbar:(UIToolbar *)toolbar;

// Navigation Controller
- (void)styleNavigationController:(UINavigationController *)navigationController;

// Bar Button
- (UIButton *)barButtonCustomView;
- (UIButton *)buttonWithTitle:(NSString*)title;
- (UIButton *)backButtonWithTitle:(NSString*)title;
- (UIBarButtonItem *)barButtonItemWithTitle:(NSString*)title action:(void(^)(void))handler;
- (UIBarButtonItem *)barButtonItemWithImage:(UIImage*)image action:(void(^)(void))handler;
- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString*)title action:(void(^)(void))handler;


@end
