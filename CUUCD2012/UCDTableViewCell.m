//
//  ERNavigationPaneCell.m
//  Erudio
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "UCDTableViewCell.h"
#import "UCDTableView.h"

@interface UCDTableViewCell ()

@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UIView *shadowView;

- (void)initialize;
- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated;

@end

@implementation UCDTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.highlightView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0);
    UITableView *enclosingTableView = (UITableView *)self.superview;
    NSIndexPath *indexPath = [enclosingTableView indexPathForCell:self];
    BOOL bottomRow = (indexPath.row == ([enclosingTableView numberOfRowsInSection:indexPath.section] - 1));
    if (!bottomRow) {
        self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - 1.0);
        self.shadowView.frame = CGRectMake(0.0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0);
        self.shadowView.alpha = 1.0;
    } else {
        self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
        self.shadowView.alpha = 0.0;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview != nil) {
        UCDTableView *enclosingTableView = (UCDTableView *)newSuperview;
        NSParameterAssert([enclosingTableView isKindOfClass:UCDTableView.class]);
        self.shadowView.backgroundColor = enclosingTableView.shadowColor;
        self.highlightView.backgroundColor = enclosingTableView.highlightColor;
        self.selectionView.backgroundColor = enclosingTableView.selectionColor;
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateBackgroundState:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateBackgroundState:selected animated:animated];
}

#pragma mark - UCDTableViewCell

- (void)initialize
{
    self.textLabel.font = [UIFont fontWithName:@"Gotham HTF" size:17.0];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.shadowColor = [UIColor whiteColor];
    self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    self.detailTextLabel.font = [UIFont fontWithName:@"Gotham HTF Book" size:13.0];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.shadowColor = [UIColor whiteColor];
    self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectionView = [[UIView alloc] init];
    [self insertSubview:self.selectionView atIndex:0.0];
    self.selectionView.alpha = 0.0;
    
    self.highlightView = [[UIView alloc] init];
    [self insertSubview:self.highlightView atIndex:0.0];
    
    self.shadowView = [[UIView alloc] init];
    [self insertSubview:self.shadowView atIndex:0.0];
}

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated
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

@end
