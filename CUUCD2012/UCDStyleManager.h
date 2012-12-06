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

// Bat Button
- (UIButton *)backButtonWithTitle:(NSString*)title;
- (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString*)title action:(void(^)(void))handler;


@end
