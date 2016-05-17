//
//  ONDUCarParkVwController.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUCarParkVwController.h"
#import "UINavigationController+LeftBtnItem.h"
#import "ONDUMapAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface ONDUCarParkVwController ()
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) MKPlacemark *placeMk;
@property (nonatomic,strong) NSMutableArray *locations;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation ONDUCarParkVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    [self.navigationController changeBackButtonItem:nil];
    self.navigationItem.title = @"Car Parking";
    self.map.delegate =  self;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.locations = [[self.userDefaults objectForKey:@"Locations"]mutableCopy];
    if ([CLLocationManager locationServicesEnabled])
    {
        if (self.locationManager == nil )
        {
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;// kDistanceFilter;
        }
        [self.locationManager startUpdatingLocation];
    }
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
    [self centerMapeOnLocation:currentLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placeMk = [[MKPlacemark alloc]initWithPlacemark:placemarks.lastObject];
            ONDUMapAnnotation *annotation = [[ONDUMapAnnotation alloc]initWithTitle:@"Park Here" withCoordinate:currentLocation.coordinate];
            [self.map addAnnotation:annotation];
            self.location = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",
                                 self.placeMk.subThoroughfare, self.placeMk.thoroughfare,
                                 self.placeMk.postalCode, self.placeMk.locality,
                                 self.placeMk.administrativeArea,
                                 self.placeMk.country];
            [self.map selectAnnotation:annotation animated:YES];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
    
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    NSString *reuseIdentifier = @"Pin";
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (pinView != nil){
        pinView.annotation = annotation;
    }
    else{
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventTouchUpInside];
    pinView.canShowCallout = YES;
    btn.tintColor = [UIColor greenColor];
    pinView.rightCalloutAccessoryView = btn;
    pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
    return pinView;
}

-(void)centerMapeOnLocation:(CLLocation*)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.map setRegion:region];
}


-(void)insertNewObject:(id)sender
{
    BOOL isInsertedObj = NO;
    if (!_locations){
        self.locations = [NSMutableArray array];
    }
    if (!self.locations.count){
        if (_location){
            isInsertedObj = YES;
        }
    }
    else{
        for (NSString *loc in _locations){
            if (![loc isEqualToString:_location]){
                isInsertedObj = YES;
            }
        }
    }
    if (isInsertedObj){
        [self.locations addObject:_location];
        [self.userDefaults setObject:_locations forKey:@"Locations"];
        [self.userDefaults synchronize];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locations.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Parking Location";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"By Clicking on (+) button on below map view, it will add the new location record on the table";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Parking %ld", indexPath.row];
    cell.detailTextLabel.text = self.locations[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:self.placeMk];
    [MKMapItem openMapsWithItems:@[mapItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit}];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.locations.count > indexPath.row)
    {
        [self.locations removeObjectAtIndex:indexPath.row];
        [self.userDefaults removeObjectForKey:@"Locations"];
        [self.userDefaults synchronize];
    }
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

@end
