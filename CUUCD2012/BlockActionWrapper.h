//
//  BlockActionWrapper.h
//  Erudio
//
//  Created by Eric Horacek on 11/7/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlockActionWrapper : NSObject

@property (nonatomic, copy) void (^blockAction)(void);

- (void)invokeBlock:(id)sender;

@end
