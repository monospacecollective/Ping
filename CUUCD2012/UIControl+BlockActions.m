//
//  UIControl+BlockActions.m
//  Erudio
//
//  Created by Eric Horacek on 9/17/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "UIControl+BlockActions.h"
#import "BlockActionWrapper.h"

#import <objc/runtime.h>

static const char * UIControlBlockActions = "UIControlDDBlockActions";

@implementation UIControl (BlockActions)

- (void)addEventHandler:(void(^)(void))handler forControlEvents:(UIControlEvents)controlEvents
{    
    NSMutableArray * blockActions = objc_getAssociatedObject(self, &UIControlBlockActions);
    if (blockActions == nil) {
        blockActions = [NSMutableArray array];
        objc_setAssociatedObject(self, &UIControlBlockActions, blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    BlockActionWrapper * target = [[BlockActionWrapper alloc] init];
    [target setBlockAction:handler];
    [blockActions addObject:target];
    
    [self addTarget:target action:@selector(invokeBlock:) forControlEvents:controlEvents];
}

@end
