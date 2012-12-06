//
//  BlockActionWrapper.m
//  Erudio
//
//  Created by Eric Horacek on 11/7/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "BlockActionWrapper.h"

@implementation BlockActionWrapper

@synthesize blockAction;

- (void)dealloc
{
    [self setBlockAction:nil];
}

- (void)invokeBlock:(id)sender
{
    [self blockAction]();
}

@end
