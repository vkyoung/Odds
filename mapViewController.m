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
    self.searchedPlaceInfo = [NSMutableArray array];

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


#pragma mark - map related


- (void) setMapWithLocation : (CLLocationDegrees) centerLatitude andLongitude: (CLLocationDegrees) centerLongitude withNewMapView: (bool) isNewView
{
    
    //set map view
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centerLatitude longitude:centerLongitude zoom:17 bearing:0 viewingAngle:70];
    
    if (isNewView == YES) {
        self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
        
    }
    else {
        [self.mapView animateToCameraPosition:camera];
    }
    
    self.mapView.mapType                   = kGMSTypeNormal;
    self.mapView.myLocationEnabled         = YES;
    self.mapView.settings.compassButton    = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:10 maxZoom:20];

    //set center location to self members
    self.mapCenterLatitude = centerLatitude;
    self.mapCenterLongitude= centerLongitude;
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
        [self setMapWithLocation:currentLocation.coordinate.latitude andLongitude:currentLocation.coordinate.longitude withNewMapView:YES];

        //[self.view addSubview:self.mapView];
        [self.view insertSubview:self.mapView atIndex:0];
        
        //stop update location
        [self.locationManager stopUpdatingLocation];
        
        
    }
    
}



#pragma mark - search related

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchTableView.hidden = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedPlaceInfo removeAllObjects];

    if([searchText length] == 0) {
        self.searchTableView.hidden = YES;
    } else {
        self.searchTableView.hidden = NO;
        
        [self queryAutoCompleteText:searchText withLat:self.mapCenterLatitude andLog:self.mapCenterLongitude withRadius:50000 toDataArray:self.searchedPlaceInfo];
    }
    
    [self.searchTableView reloadData];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchedPlaceInfo count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    SUPlaceInfo *selectedItem = self.searchedPlaceInfo[indexPath.row];
    cell.textLabel.text = selectedItem.description;
    

    
    if(selectedItem.formattedAddress != nil) {
        cell.detailTextLabel.text = selectedItem.formattedAddress;
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SUPlaceInfo *placeInfo = self.searchedPlaceInfo[indexPath.row];
    
    if(placeInfo.reference == nil) {
//        NSLog(@"Null reference, need to further processed");

        NSString *searchText = placeInfo.description;
        
        [self.searchedPlaceInfo removeAllObjects];
        
        [self queryDataWithText:searchText withLat:self.mapCenterLatitude andLog:self.mapCenterLongitude withRadius:5000 toDataArray:self.searchedPlaceInfo];
        
        [tableView reloadData];
        
    }else {
        NSString *reference = placeInfo.reference;
        [self parseDetailedPlaceInfoTo:placeInfo withReference:reference];
//        NSLog(@"%.2f %.2f", placeInfo.latitude, placeInfo.longitude);

        
        //hide search table view hidden
        [self.searchDisplayController setActive:NO];
        self.searchTableView.hidden = YES;
        
        //relocate the map view position
        [self setMapWithLocation:placeInfo.latitude andLongitude:placeInfo.longitude withNewMapView:NO];
        
        
    }
    
}

-(void) queryDataWithText: (NSString *) queryText withLat:(CLLocationDegrees)latitude andLog:(CLLocationDegrees)longitude withRadius:(int)radius toDataArray: (NSMutableArray *) dataArray
{
    NSString *codedQueryText = [queryText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *radiusString = [NSString stringWithFormat:@"%d", (int)radius];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", (double)latitude, (double)longitude];

    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&sensor=true&query=%@&location=%@&radius=%@", kGOOGLE_BROWSER_API_KEY, codedQueryText, locationString, radiusString];
    
//    NSLog(@"%@", url);
    
    NSURL *urlObj=[NSURL URLWithString:url];
    NSData *urlData = [NSData dataWithContentsOfURL:urlObj];
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    
    NSDictionary *dataSet = jsonData[@"results"];

//    NSLog(@"%@", dataSet);
    
    for(NSDictionary *oneData in dataSet) {
        
        SUPlaceInfo *placeInfo = [SUPlaceInfo placeInfoWithDescription:oneData[@"name"]];
        
        placeInfo.reference = oneData[@"reference"];
        [self parseDetailedPlaceInfoTo:placeInfo withPlaceDictionary:oneData];

//        NSLog(@"%@, %@", placeInfo.description, placeInfo.formattedAddress);
        
        [dataArray addObject:placeInfo];
    }
    
}

-(void) queryAutoCompleteText: (NSString *) queryText withLat:(CLLocationDegrees)latitude andLog:(CLLocationDegrees)longitude withRadius:(int)radius toDataArray: (NSMutableArray *) dataArray
{
    NSString *codedQueryText = [queryText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *radiusString = [NSString stringWithFormat:@"%d", (int)radius];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", (double)latitude, (double)longitude];
    
//    NSLog(@"%@, [%@]", radiusString, locationString);
    
    
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=%@&sensor=true&input=%@&location=%@&radius=%@", kGOOGLE_BROWSER_API_KEY, codedQueryText, locationString, radiusString];
    
    //Formulate the string as a URL object.
    NSURL *urlObj=[NSURL URLWithString:url];
    NSData *urlData = [NSData dataWithContentsOfURL:urlObj];
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];

    
    NSDictionary *dataSet = jsonData[@"predictions"];
    
    for(NSDictionary *oneData in dataSet) {
       
        SUPlaceInfo *placeInfo = [SUPlaceInfo placeInfoWithDescription:oneData[@"description"]];
        
        if(oneData[@"reference"] != nil) {
            placeInfo.reference = oneData[@"reference"];
//            NSLog(@"%@", placeInfo.reference);
            [self parseDetailedPlaceInfoTo:placeInfo withReference:placeInfo.reference];
//            NSLog(@"%@", placeInfo.formattedAddress);
        }
        
        [dataArray addObject:placeInfo];
    }
}


-(void) parseDetailedPlaceInfoTo: (SUPlaceInfo *) placeInfo withReference: (NSString *)reference
{    
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", reference, kGOOGLE_BROWSER_API_KEY];
    NSURL *urlObj=[NSURL URLWithString:url];
    NSData *urlData = [NSData dataWithContentsOfURL:urlObj];
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];

    
    
    NSDictionary *allField = jsonData[@"result"];
    
    [self parseDetailedPlaceInfoTo:placeInfo withPlaceDictionary:allField];
}


-(void) parseDetailedPlaceInfoTo:(SUPlaceInfo *)placeInfo withPlaceDictionary: (NSDictionary *)placeFields
{
    //address
    placeInfo.formattedAddress = placeFields[@"formatted_address"];

    
    //latitude and longitude
    NSDictionary *geometryField = placeFields[@"geometry"];
    NSDictionary *locationField = geometryField[@"location"];
    placeInfo.latitude = [locationField[@"lat"] floatValue];
    placeInfo.longitude = [locationField[@"lng"] floatValue];
    
}



@end
