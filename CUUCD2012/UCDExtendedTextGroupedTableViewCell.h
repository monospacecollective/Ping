//
//  UCDExtendedTextGroupedTableViewCell.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewCell.h"

extern NSString * const UCDExtendedTextReuseIdentifier;

@interface UCDExtendedTextGroupedTableViewCell : UCDGroupedTableViewCell

+ (CGFloat)cellHeightForText:(NSString *)text cellWidth:(CGFloat)width;

@end
