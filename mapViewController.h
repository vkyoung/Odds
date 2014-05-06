//
//  mapViewController.h
//  odds
//
//  Created by Chia-YangTsai on 2014/5/3.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface mapViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTextField;



//variables
@property (nonatomic, strong) NSArray *retrivedItems;
@property (nonatomic, strong) NSMutableArray *filteredItems;

//methods

- (void) setMapWithLocation : (CLLocation *)location;

@end
