//
//  ERNavigationPaneCell.h
//  Erudio
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCDTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (strong, nonatomic) UIColor *shadowColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIColor *selectionColor;

@end
