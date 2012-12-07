//
//  UCDWelcomeViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomeViewController.h"
#import "UCDNavigationTitleView.h"
#import "UCDWelcomeStepsView.h"
#import "UCDStyleManager.h"
#import "UCDWelcomePageView.h"
#import "UCDWelcomePageViewAccept.h"
#import "UCDWelcomePageViewDuration.h"
#import "UCDWelcomePageViewAccuracy.h"
#import "UCDWelcomePageViewAbout.h"
#import "UCDWelcomePageViewComplete.h"
#import "UCDAppDelegate.h"
#import "UCDUser.h"

const NSUInteger UCDWelcomeViewPageCount = 5;

@interface UCDWelcomeViewController ()

@property (nonatomic, strong) UCDNavigationTitleView *titleView;
@property (nonatomic, strong) UCDWelcomeStepsView *welcomeStepsView;
@property (nonatomic, strong) NSArray *welcomePages;
@property (nonatomic, strong) UIScrollView *welcomeScrollView;
@property (nonatomic, strong) UIBarButtonItem *previousPageBarButtonItem;
@property (nonatomic, strong) NSArray *welcomePageTitles;

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;
- (NSUInteger)currentPage;

@end

@implementation UCDWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.welcomePageTitles = @[
            @"1. Welcome to Ping",
            @"2. Collection Interval",
            @"3. Location Interval",
            @"4. About You",
            @"5. Get Started!",
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    [[UCDStyleManager sharedManager] styleToolbar:self.navigationController.toolbar];
    
    self.titleView = [[UCDNavigationTitleView alloc] init];
    self.titleView.title.text = @"Welcome";
    self.titleView.subtitle.text = self.welcomePageTitles[0];
    self.navigationItem.titleView = self.titleView;
    
    __weak typeof(self) blockSelf = self;
    
    UCDUser *user = [[UCDUser alloc] initWithEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
    
    self.previousPageBarButtonItem = [[UCDStyleManager sharedManager] backBarButtonItemWithTitle:@"Back" action:^{
        [blockSelf scrollToPage:(blockSelf.currentPage - 1) animated:YES];
    }];
    self.navigationItem.leftBarButtonItem = self.previousPageBarButtonItem;
    self.previousPageBarButtonItem.customView.alpha = 0.0;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12.0;
    
    self.welcomeStepsView = [[UCDWelcomeStepsView alloc] init];
    self.welcomeStepsView.visibleSteps = 1;
    
    UIBarButtonItem *stepsWellBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.welcomeStepsView];
    self.toolbarItems = @[negativeSpacer, stepsWellBarItem];
    
    self.welcomeScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.welcomeScrollView.pagingEnabled = YES;
    A2DynamicDelegate *scrollViewDelegate = [self.welcomeScrollView dynamicDelegateForProtocol:@protocol(UIScrollViewDelegate)];
    [scrollViewDelegate implementMethod:@selector(scrollViewDidScroll:) withBlock:^(UIScrollView *scrollView){
        CGFloat alpha = (blockSelf.currentPage > 0) ? 1.0 : 0.0;
        if (blockSelf.previousPageBarButtonItem.customView.alpha != alpha) {
            [UIView animateWithDuration:0.3 animations:^{
                blockSelf.previousPageBarButtonItem.customView.alpha = alpha;
            }];
        }
    }];
    self.welcomeScrollView.delegate = (id<UIScrollViewDelegate>)scrollViewDelegate;
    self.welcomeScrollView.showsVerticalScrollIndicator = NO;
    self.welcomeScrollView.showsHorizontalScrollIndicator = NO;
    self.welcomeScrollView.scrollEnabled = NO;
    [self.view addSubview:self.welcomeScrollView];
    
    NSMutableArray *welcomePages = [NSMutableArray arrayWithCapacity:UCDWelcomeViewPageCount];
    
    UCDWelcomePageViewAccept *welcomePage1 = [[UCDWelcomePageViewAccept alloc] initWithFrame:self.view.bounds];
    [welcomePage1.acceptButton addEventHandler:^{
        [blockSelf scrollToPage:(blockSelf.currentPage + 1) animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [welcomePages addObject:welcomePage1];
    [self.welcomeScrollView addSubview:welcomePage1];
    
    UCDWelcomePageViewDuration *welcomePage2 = [[UCDWelcomePageViewDuration alloc] initWithFrame:self.view.bounds];
    A2DynamicDelegate *welcomePage2Delegate = [welcomePage2 dynamicDelegateForProtocol:@protocol(UCDWelcomePageViewDurationDelegate)];
    [welcomePage2Delegate implementMethod:@selector(welcomePageViewDuration:didSelectDuration:) withBlock:^(UCDWelcomePageViewDuration *welcomePageViewDuration, UCDUserDurationInterval durationInterval){
        NSLog(@"Duration interval %d", durationInterval);
        user.locationCollectionInterval = @(durationInterval);
        [blockSelf scrollToPage:(blockSelf.currentPage + 1) animated:YES];
    }];
    welcomePage2.delegate = (id<UCDWelcomePageViewDurationDelegate>)welcomePage2Delegate;
    [welcomePages addObject:welcomePage2];
    [self.welcomeScrollView addSubview:welcomePage2];

    UCDWelcomePageViewAccuracy *welcomePage3 = [[UCDWelcomePageViewAccuracy alloc] initWithFrame:self.view.bounds];
    A2DynamicDelegate *welcomePage3Delegate = [welcomePage3 dynamicDelegateForProtocol:@protocol(UCDWelcomePageViewAccuracyDelegate)];
    [welcomePage3Delegate implementMethod:@selector(welcomePageViewAccuracy:didSelectAccuracy:) withBlock:^(UCDWelcomePageViewAccuracy *welcomePageViewAccuracy, UCDUserAccuracyInterval accuracyInterval){
        NSLog(@"Accuracy interval %d", accuracyInterval);
        user.locationAccuracyRadius = @(accuracyInterval);
        [blockSelf scrollToPage:(blockSelf.currentPage + 1) animated:YES];
    }];
    welcomePage3.delegate = (id<UCDWelcomePageViewAccuracyDelegate>)welcomePage3Delegate;
    [welcomePages addObject:welcomePage3];
    [self.welcomeScrollView addSubview:welcomePage3];

    UCDWelcomePageViewAbout *welcomePage4 = [[UCDWelcomePageViewAbout alloc] initWithFrame:self.view.bounds];
    [welcomePage4.doneButton addEventHandler:^{
        user.occupation = @"Student";
        user.gender = @"Male";
        user.birthday = [NSDate date];
        [blockSelf scrollToPage:(blockSelf.currentPage + 1) animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [welcomePages addObject:welcomePage4];
    [self.welcomeScrollView addSubview:welcomePage4];

    UCDWelcomePageViewComplete *welcomePage5 = [[UCDWelcomePageViewComplete alloc] initWithFrame:self.view.bounds];
    [welcomePage5.completeButton addEventHandler:^{
        [self.managedObjectContext MR_save];
        [[UCDAppDelegate sharedAppDelegate] welcomeComplete];
    } forControlEvents:UIControlEventTouchUpInside];
    [welcomePages addObject:welcomePage5];
    [self.welcomeScrollView addSubview:welcomePage5];
    
    self.welcomePages = [NSArray arrayWithArray:welcomePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    CGRect workingRect = self.view.bounds;
    for (NSUInteger currentPage = 0; currentPage < UCDWelcomeViewPageCount; currentPage++) {
        UCDWelcomePageView *pageView = self.welcomePages[currentPage];
        pageView.frame = workingRect;
        workingRect = CGRectOffset(workingRect, CGRectGetWidth(self.welcomeScrollView.frame), 0.0);
    }
    self.welcomeScrollView.contentSize = CGSizeMake(CGRectGetMinX(workingRect), workingRect.size.height);
}

#pragma mark - UCDWelcomeViewController

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated
{
    if ((page >= UCDWelcomeViewPageCount) || (page == self.currentPage)) {
        return;
    }
    UCDNavigationTitleViewAnimationDirection direction = ((self.currentPage < page) ? UCDNavigationTitleViewAnimationDirectionLeft : UCDNavigationTitleViewAnimationDirectionRight);
    
    self.welcomeStepsView.visibleSteps = (page + 1);
    CGFloat pageWidth = self.welcomeScrollView.frame.size.width;
    [self.welcomeScrollView setContentOffset:CGPointMake((pageWidth * page), 0.0) animated:animated];
    [self.titleView setSubtitleText:self.welcomePageTitles[page] animated:animated direction:direction];
}

- (NSUInteger)currentPage
{
    CGFloat pageWidth = self.welcomeScrollView.frame.size.width;
    float fractionalPage = (self.welcomeScrollView.contentOffset.x / pageWidth);
    NSInteger pageNumber = nearbyint(fractionalPage);
    return pageNumber;
}

@end
