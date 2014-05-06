//
//  mapViewController.m
//  odds
//
//  Created by Chia-YangTsai on 2014/5/3.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import "mapViewController.h"

@interface mapViewController ()

@end

@implementation mapViewController

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //allocate and initialize location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    //search table initilization
    self.searchTableView.hidden = YES;
    
    //initial variables
    self.retrivedItems = [[NSArray alloc] initWithObjects:@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", @"nine", @"ten", @"eleven", @"twelve", @"thirteen", @"forteen", nil];
    self.filteredItems = [[NSMutableArray alloc] initWithArray:self.retrivedItems];
    
    //hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];


    self.mapView.padding =
    UIEdgeInsetsMake(self.topLayoutGuide.length + 5,
                     0,
                     self.bottomLayoutGuide.length + 5,
                     0);
    
    
}


- (BOOL) prefersStatusBarHidden {
    return YES;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setting map

- (void) setMapWithLocation:(CLLocation *)location
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: location.coordinate.latitude  longitude:location.coordinate.longitude zoom:16 bearing:0 viewingAngle:0];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.mapType                   = kGMSTypeNormal;
    self.mapView.myLocationEnabled         = YES;
    self.mapView.settings.compassButton    = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:10 maxZoom:20];
    
}



#pragma mark - CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location Update Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];

    if(currentLocation != nil) {
        //give current location to the map and show it
        [self setMapWithLocation:currentLocation];
        //[self.view addSubview:self.mapView];
        [self.view insertSubview:self.mapView atIndex:0];
        
        //stop update location
        [self.locationManager stopUpdatingLocation];
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - search bar and table view

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        self.searchTableView.hidden = YES;
        [self.filteredItems removeAllObjects];
    } else {
        self.searchTableView.hidden = NO;
        [self.filteredItems removeAllObjects];
        for(NSString *oneString in self.retrivedItems) {
            NSRange r = [oneString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound) {
                [self.filteredItems addObject:oneString];
            }
        }
    }
    
    [self.searchTableView reloadData];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredItems count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.filteredItems[indexPath.row];
    return cell;
}


@end
