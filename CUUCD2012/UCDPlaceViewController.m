//
//  UCDPlaceViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlaceViewController.h"
#import "UCDNavigationTitleView.h"
#import "UCDStyleManager.h"

typedef NS_ENUM(NSUInteger, UCDPlaceTableViewSection) {
    UCDPlaceTableViewSectionInfo,
    UCDPlaceTableViewSectionMap,
    UCDPlaceTableViewSectionAttributes,
    UCDPlaceTableViewSectionCount,
};

typedef NS_ENUM(NSUInteger, UCDPlaceTableViewSectionInfoRow) {
    UCDPlaceTableViewSectionInfoRowName,
    UCDPlaceTableViewSectionInfoRowDetail,
    UCDPlaceTableViewSectionInfoRowCount,
};

typedef NS_ENUM(NSUInteger, UCDPlaceTableViewSectionMapRow) {
    UCDPlaceTableViewSectionMapRowGeocode,
    UCDPlaceTableViewSectionMapRowMap,
    UCDPlaceTableViewSectionMapRowCount,
};

typedef NS_ENUM(NSUInteger, UCDPlaceTableViewSectionAttributesRow) {
    UCDPlaceTableViewSectionAttributesRowPeopleHere,
    UCDPlaceTableViewSectionAttributesRowRating,
    UCDPlaceTableViewSectionAttributesRowFavorite,
    UCDPlaceTableViewSectionAttributesRowCount,
};

@interface UCDPlaceViewController ()

@property (nonatomic, strong) id managedObjectContextUpdateObserver;
@property (nonatomic, strong) CLPlacemark *geocodedPlacemark;

@end

@implementation UCDPlaceViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.managedObjectContextUpdateObserver];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Place" subtitle:self.place.name];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.place.location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Geocoded! %@", placemarks);
        if (!error) {
            self.geocodedPlacemark = placemarks[0];
            [self.tableView reloadData];
        }
    }];
    
    self.managedObjectContextUpdateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext queue:NULL usingBlock:^(NSNotification *notification) {
        for (NSManagedObject *object in [notification.userInfo objectForKey:NSUpdatedObjectsKey]) {
            if (object == self.place) {
                [self.tableView reloadData];
            }
        }
    }];
    
    __weak typeof(self) blockSelf = self;
    SSPullToRefreshView *refreshView = [[UCDStyleManager sharedManager] pullToRefreshViewWithScrollView:self.tableView];
    A2DynamicDelegate *refreshViewDelegate = [refreshView dynamicDelegateForProtocol:@protocol(SSPullToRefreshViewDelegate)];
    [refreshViewDelegate implementMethod:@selector(pullToRefreshViewDidStartLoading:) withBlock:^(SSPullToRefreshView *view){
        [refreshView startLoading];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF == %@", self.place];
        [blockSelf.managedObjectContext performBlockAndWait:^{
            [blockSelf.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        }];
        [refreshView finishLoading];
    }];
    refreshView.delegate = (id<SSPullToRefreshViewDelegate>)refreshViewDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return UCDPlaceTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case UCDPlaceTableViewSectionInfo:
            return UCDPlaceTableViewSectionInfoRowCount - ((self.place.detail || [self.place.detail isEqualToString:@""]) ? 0 : 1);
        case UCDPlaceTableViewSectionMap:
            return UCDPlaceTableViewSectionMapRowCount;
        case UCDPlaceTableViewSectionAttributes:
            return UCDPlaceTableViewSectionAttributesRowCount;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case UCDPlaceTableViewSectionInfo: {
            switch (indexPath.row) {
                case UCDPlaceTableViewSectionInfoRowName: {
                    cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
                    cell.textLabel.text = self.place.name;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case UCDPlaceTableViewSectionInfoRowDetail: {
                    cell = [tableView dequeueReusableCellWithIdentifier:UCDExtendedTextReuseIdentifier forIndexPath:indexPath];
                    cell.textLabel.text = self.place.detail;
                    break;
                }
            }
            break;
        }
        case UCDPlaceTableViewSectionMap: {
            switch (indexPath.row) {
                case UCDPlaceTableViewSectionMapRowGeocode: {
                    cell = [tableView dequeueReusableCellWithIdentifier:UCDSubtitleReuseIdentifier forIndexPath:indexPath];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    NSString *address = ABCreateStringWithAddressDictionary(self.geocodedPlacemark.addressDictionary, NO);
                    if (!self.geocodedPlacemark.name) {
                        cell.textLabel.text = @"Loading...";
                    } else if ([self.geocodedPlacemark.name isEqualToString:self.geocodedPlacemark.addressDictionary[(NSString *)kABPersonAddressStreetKey]]) {
                        cell.textLabel.text = self.geocodedPlacemark.name;
                    } else {
                        cell.textLabel.text = self.geocodedPlacemark.name;
                        cell.detailTextLabel.text = address;
                    }
                    break;
                }
                case UCDPlaceTableViewSectionMapRowMap: {
                    cell = [tableView dequeueReusableCellWithIdentifier:UCDMapReuseIdentifier forIndexPath:indexPath];
                    ((UCDMapGroupedTableViewCell *)cell).coordinate = self.place.location.coordinate;
                    break;
                }
            }
            break;
        }
        case UCDPlaceTableViewSectionAttributes: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
            switch (indexPath.row) {
                case UCDPlaceTableViewSectionAttributesRowPeopleHere: {
                    cell.textLabel.text = @"People Here";
                    cell.detailTextLabel.text = self.place.peopleHereDescripton;
                    break;
                }
                case UCDPlaceTableViewSectionAttributesRowRating: {
                    cell.textLabel.text = @"Rating";
                    cell.detailTextLabel.text = self.place.starRating;
                    break;
                }
                case UCDPlaceTableViewSectionAttributesRowFavorite: {
                    cell.textLabel.text = @"Favorite";
                    cell.detailTextLabel.text = @"No";
                    break;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }       
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case UCDPlaceTableViewSectionInfo:
            switch (indexPath.row) {
                case UCDPlaceTableViewSectionInfoRowDetail:
                    return [UCDExtendedTextGroupedTableViewCell cellHeightForText:self.place.detail cellWidth:CGRectGetWidth(self.tableView.frame)];
            }
        case UCDPlaceTableViewSectionMap:
            switch (indexPath.row) {
                case UCDPlaceTableViewSectionMapRowMap:
                    return [UCDMapGroupedTableViewCell cellHeight];
            }
        default:
            return [UCDGroupedTableViewCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
