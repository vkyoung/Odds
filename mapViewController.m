//
//  mapViewController.m
//  odds
//
//  Created by Chia-YangTsai on 2014/5/3.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import "mapViewController.h"
#import "SUPlaceInfo.h"

@interface mapViewController ()

@end

@implementation mapViewController

//@synthesize mapCenterLatitude;
//@synthesize mapCenterLongitude;

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

- (void) setMapWithLocation : (CLLocationDegrees) centerLatitude andLongitude: (CLLocationDegrees) centerLongitude;
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centerLatitude longitude:centerLongitude zoom:15 bearing:0 viewingAngle:0];
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
        
        self.mapCenterLatitude = currentLocation.coordinate.latitude;
        self.mapCenterLongitude= currentLocation.coordinate.longitude;
        
        //give current location to the map and show it
        [self setMapWithLocation:self.mapCenterLatitude andLongitude:self.mapCenterLongitude];

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
        
        [self getSearchItems:searchText];
        
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    SUPlaceInfo *selectedItem = self.searchedPlaceInfo[indexPath.row];
    cell.textLabel.text = selectedItem.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SUPlaceInfo *placeInfo = self.searchedPlaceInfo[indexPath.row];
    
    if(placeInfo.reference == nil) {
        //finish the text
        
    }else {
        //directly go to page
    }
    
    /*
    self.searchTableView.hidden = YES;

    NSString *referenceString = self.filteredReferences[indexPath.row];
    NSLog(@"%@", referenceString);

    
    
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", referenceString, kGOOGLE_BROWSER_API_KEY];
    NSURL *urlObj=[NSURL URLWithString:url];
    NSData *urlData = [NSData dataWithContentsOfURL:urlObj];
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];

    NSDictionary *placeInfo = jsonData[@"result"];
    NSLog(@"%@", placeInfo);
*/
}

-(void) getSearchItems: (NSString *) queryText
{
    NSString *codedQueryText = [queryText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=%@&sensor=true&input=%@", kGOOGLE_BROWSER_API_KEY, codedQueryText ];
    
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
        }
        
        [self.searchedPlaceInfo addObject:placeInfo];
    }
}







@end
