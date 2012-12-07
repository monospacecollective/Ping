//
//  ERNavigationPaneTableView.h
//  Erudio
//
//  Created by Eric Horacek on 6/19/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCDTableView : UITableView

@property (strong, nonatomic) UIColor *shadowColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (assign, nonatomic) CGFloat lineOffset;

@end
