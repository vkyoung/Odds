//
//  mapViewController.h
//  odds
//
//  Created by Chia-YangTsai on 2014/5/3.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SUPlaceInfo.h"

#define kGOOGLE_BROWSER_API_KEY @"AIzaSyDNAcReYgdx33lDHhGiydKUUTSC6e8AXOU"


@interface mapViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - view
@property (nonatomic, strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTextField;
@property (nonatomic, strong) CLLocationManager *locationManager;


#pragma mark - map related
@property (nonatomic) CLLocationDegrees mapCenterLatitude;
@property (nonatomic) CLLocationDegrees mapCenterLongitude;

- (void) setMapWithLocation : (CLLocationDegrees) centerLatitude andLongitude: (CLLocationDegrees) centerLongitude withNewMapView: (bool) isNewView;



#pragma mark - search related
@property (nonatomic, strong) NSMutableArray *searchedPlaceInfo;
-(void) queryAutoCompleteText: (NSString *) queryText withLat:(CLLocationDegrees)latitude andLog:(CLLocationDegrees)longitude withRadius:(int)radius toDataArray: (NSMutableArray *) dataArray;
-(void) parseDetailedPlaceInfoTo: (SUPlaceInfo *) placeInfo withReference: (NSString *)reference;
-(void) parseDetailedPlaceInfoTo:(SUPlaceInfo *)placeInfo withPlaceDictionary: (NSDictionary *)placeFields;


@end
