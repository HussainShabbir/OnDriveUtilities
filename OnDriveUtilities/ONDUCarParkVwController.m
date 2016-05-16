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
@end

@implementation ONDUCarParkVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    [self.navigationController changeBackButtonItem:nil];
    self.navigationItem.title = @"Car Parking";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.map.delegate =  self;
//    self.map.showsUserLocation = YES;
    if ([CLLocationManager locationServicesEnabled] )
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
    else{
        
    }
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    CLLocation *location = [[self trackUpdatedLocation]location];
//    [self updateLocation:location];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.map addGestureRecognizer:tapRecognizer];
    // Do any additional setup after loading the view.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingHeading];
    CLLocation *location = [locations lastObject];
    [self centerMapeOnLocation:location];
    // here we get the current location
}

-(void)updateLocation:(CLLocation*)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         CLPlacemark *mark = placemark[0];
         [self centerMapeOnLocation:location];
         self.placeMk = [[MKPlacemark alloc]initWithPlacemark:mark];
         self.location = self.placeMk.title;
         [self.map addAnnotation:_placeMk];

     }];
}

-(void)foundTap:(UITapGestureRecognizer *)recognizer {
    [self.map removeAnnotation:_placeMk];
    CGPoint point = [recognizer locationInView:_map];
    CLLocationCoordinate2D tapPoint = [self.map convertPoint:point toCoordinateFromView:_map];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = tapPoint;
//    [self.map addAnnotation:point1];
//    CLLocation *location = [[CLLocation alloc]initWithCoordinate:tapPoint altitude:CLLocationDistanceMax horizontalAccuracy:kCLLocationAccuracyBestForNavigation verticalAccuracy:kCLLocationAccuracyBestForNavigation timestamp:[NSDate date]];
//    [self updateLocation:location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CLLocationManager*)trackUpdatedLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    return _locationManager;
}

-(void)centerMapeOnLocation:(CLLocation*)location{
    CLLocationDistance regionRadius = 1000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0);
    [self.map setRegion:region];
}

-(void)insertNewObject:(id)sender
{
    
}

@end
