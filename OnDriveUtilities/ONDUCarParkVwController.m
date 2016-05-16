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
@end

@implementation ONDUCarParkVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    [self.navigationController changeBackButtonItem:@"Car Parking"];
    CLLocation *location = [[self trackUpdatedLocation]location];
    
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
         MKPlacemark *placeMk = [[MKPlacemark alloc]initWithPlacemark:mark];
         [self.map addAnnotation:placeMk];
     }];

    // Do any additional setup after loading the view.
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

@end
