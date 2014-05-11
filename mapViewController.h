//
//  mapViewController.h
//  odds
//
//  Created by Chia-YangTsai on 2014/5/3.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#define kGOOGLE_BROWSER_API_KEY @"AIzaSyDNAcReYgdx33lDHhGiydKUUTSC6e8AXOU"
//#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface mapViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - view
@property (nonatomic, strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTextField;
@property (nonatomic, strong) CLLocationManager *locationManager;


#pragma mark - map related
@property (assign) CLLocationDegrees mapCenterLatitude;
@property (assign) CLLocationDegrees mapCenterLongitude;

- (void) setMapWithLocation : (CLLocationDegrees) centerLatitude andLongitude: (CLLocationDegrees) centerLongitude;



#pragma mark - search related
@property (nonatomic, strong) NSMutableArray *searchedPlaceInfo;
//@property (nonatomic, strong) NSMutableArray *filteredNames;
//@property (nonatomic, strong) NSMutableArray *filteredReferences;
-(void) getSearchItems: (NSString *) queryText;


@end
