//
//  UCDBorderedLabel.h
//  Erudio
//
//  Created by Eric Horacek on 1/19/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCDBorderedLabel : UILabel

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *borderShadowColor;
@property (assign, nonatomic) UIEdgeInsets textEdgeInsets;
@property (assign, nonatomic) BOOL shouldFill;

@end
