//
//  UIControl+BlockActions.h
//  Erudio
//
//  Created by Eric Horacek on 9/17/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BlockActions)

- (void)addEventHandler:(void(^)(void))handler forControlEvents:(UIControlEvents)controlEvents;

@end
