//
//  UCDMasterTableView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterTableView.h"

@implementation UCDMasterTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.highlightColor = [[UIColor whiteColor] colorWithAlphaComponent:0.075];
        self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.selectionColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDMasterTableViewBackground"]];
        self.backgroundView = backgroundView;
    }
    return self;
}

@end
