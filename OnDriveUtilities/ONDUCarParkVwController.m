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
@property (nonatomic,strong) NSMutableArray *locations;
@property (nonatomic,strong) ONDUMapAnnotation *annotation;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation ONDUCarParkVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    [self.navigationController changeBackButtonItem:nil withCurrentObject:self];
    self.navigationItem.title = @"Car Parking";
    self.map.delegate =  self;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *decodeData = [self.userDefaults objectForKey:@"PlaceMark"];
    if (decodeData != nil){
        self.locations = [[NSKeyedUnarchiver unarchiveObjectWithData:decodeData]mutableCopy];
    }
    if ([CLLocationManager locationServicesEnabled])
    {
        if (self.locationManager == nil )
        {
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
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
            MKPlacemark *placeMk = [[MKPlacemark alloc]initWithPlacemark:placemarks.lastObject];
            NSString *location = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",
                             placeMk.subThoroughfare, placeMk.thoroughfare,
                             placeMk.postalCode, placeMk.locality,
                             placeMk.administrativeArea,
                             placeMk.country];
            self.annotation = [[ONDUMapAnnotation alloc]initWithTitle:@"Park Here" withSubTitle:nil withCoordinate:currentLocation.coordinate withPlaceMarkTitle:placeMk.title andLocationName:location];
            [self.map addAnnotation:self.annotation];
            [self.map selectAnnotation:self.annotation animated:YES];
        }
        else
        {
            [self showAlertWithTitle:@"Unavailable network" andMessage:@"Please check the network and relauch the app"];
            return;
        }
    }];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if (!self.annotation.locationName){
        return nil;
    }
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
    btn.tintColor = [UIColor darkTextColor];
    pinView.rightCalloutAccessoryView = btn;
    pinView.pinTintColor = [UIColor colorWithRed:(91/255.0f) green:(160/255.0f) blue:(36/255.0f) alpha:1.0f];
    return pinView;
}

-(void)centerMapeOnLocation:(CLLocation*)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.map setRegion:region];
}


-(void)insertNewObject:(id)sender{
    if (!self.locations){
        self.locations = [NSMutableArray arrayWithCapacity:0];
    }
    if (![self.annotation isLocationAvailable:self.locations]){
        @try {
            [self.locations addObject:_annotation];
            [self encodeLocation];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.locations.count) ? (self.locations.count-1) : 0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        @catch (NSException *exception) {
            [self showAlertWithTitle:@"Ivalid Data" andMessage:@"Location cannot be added"];
        }
    }
    else{
        [self showAlertWithTitle:@"Location already Exist" andMessage:@"Please check on the table"];
    }
}

-(void)encodeLocation
{
    NSData *enCodedData = [NSKeyedArchiver archivedDataWithRootObject:_locations];
    [self.userDefaults setObject:enCodedData forKey:@"PlaceMark"];
    [self.userDefaults synchronize];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    alertController.view.tintColor = [UIColor blackColor];
    [self presentViewController:alertController animated:YES completion:nil];
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
    cell.textLabel.text = [NSString stringWithFormat:@"Parking %ld", (long)indexPath.row];
    ONDUMapAnnotation *currentAnnotation = self.locations[indexPath.row];
    cell.detailTextLabel.text = currentAnnotation.locationName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ONDUMapAnnotation *selectedAnnotation = self.locations[indexPath.row];
    [MKMapItem openMapsWithItems:@[selectedAnnotation.mapItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit}];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.locations.count > indexPath.row)
    {
        [self.locations removeObjectAtIndex:indexPath.row];
        
        [self.userDefaults removeObjectForKey:@"PlaceMark"];
        [self encodeLocation];
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
