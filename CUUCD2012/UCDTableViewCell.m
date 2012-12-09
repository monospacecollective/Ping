//
//  ERNavigationPaneCell.m
//  Erudio
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "UCDTableViewCell.h"

@interface UCDTableViewCell ()

@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UIView *shadowView;

- (void)initialize;

@end

@implementation UCDTableViewCell

@synthesize iconView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.superview isKindOfClass:UITableView.class]) {
        
        UITableView *enclosingTableView = (UITableView *)self.superview;
        NSIndexPath *indexPath = [enclosingTableView indexPathForCell:self];
        
        BOOL bottomRow = (indexPath.row == ([enclosingTableView numberOfRowsInSection:indexPath.section] - 1));
        
        self.highlightView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0);
        
        if (!bottomRow) {
            self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - 1.0);
            self.shadowView.frame = CGRectMake(0.0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0);
            self.shadowView.alpha = 1.0;
        } else {
            self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
            self.shadowView.alpha = 0.0;
        }
    }
}

- (void)initialize
{
    self.highlightColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.selectionColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectionView = [[UIView alloc] init];
    [self insertSubview:self.selectionView atIndex:0.0];
    self.selectionView.backgroundColor = self.selectionColor;
    self.selectionView.alpha = 0.0;
    
    self.highlightView = [[UIView alloc] init];
    [self insertSubview:self.highlightView atIndex:0.0];
    self.highlightView.backgroundColor = self.highlightColor;

    self.shadowView = [[UIView alloc] init];
    [self insertSubview:self.shadowView atIndex:0.0];
    self.shadowView.backgroundColor = self.shadowColor;

}

- (void)setBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    void(^updateBackgroundState)() = ^() {
        self.selectionView.alpha = (darkened ? 1.0 : 0.0);
        self.highlightView.alpha = (darkened ? 0.0 : 1.0);
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:updateBackgroundState];
    } else {
        updateBackgroundState();
    }
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setBackgroundState:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setBackgroundState:selected animated:animated];
}

@end
