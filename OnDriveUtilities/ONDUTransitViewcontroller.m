//
//  ONDUTransitViewcontroller.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/22/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUTransitViewcontroller.h"
#import <CoreLocation/CoreLocation.h>
#import "UINavigationController+LeftBtnItem.h"

@interface ONDUTransitViewcontroller ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSArray *matchingItems;
@property (nonatomic,strong) NSMutableArray *locations;

@end

@implementation ONDUTransitViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController changeBackButtonItem:nil withCurrentObject:self];
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
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"gas station";
    request.region = self.mapVw.region;
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.mapItems.count){
            return;
        }
        self.matchingItems = response.mapItems;
    }];
    
    // Do any additional setup after loading the view.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
    [self centerMapeOnLocation:currentLocation];
}


-(void)centerMapeOnLocation:(CLLocation*)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.mapVw setRegion:region];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
