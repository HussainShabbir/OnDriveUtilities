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
#import "ONDUMapAnnotation.h"
@interface ONDUTransitViewcontroller ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSArray *matchingItems;
@property (nonatomic,strong) NSMutableArray *locations;

@end

@implementation ONDUTransitViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController changeBackButtonItem:nil withCurrentObject:self];
    self.navigationItem.title = self.selectedTransit;
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
    
    // Do any additional setup after loading the view.
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    MKPinAnnotationView *pinView = nil;
    if (annotation != mapView.userLocation)
    {
        NSString *reuseIdentifier = @"Pin";
        pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (pinView != nil){
            pinView.annotation = annotation;
        }
        else
        {
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        pinView.pinTintColor = [UIColor colorWithRed:(91/255.0f) green:(160/255.0f) blue:(36/255.0f) alpha:1.0f];
        pinView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = button;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    ONDUMapAnnotation *location = (ONDUMapAnnotation*)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
    [self centerMapeOnLocation:currentLocation];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = self.selectedTransit;
    request.region = self.mapVw.region;
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.mapItems.count){
            return;
        }
        self.matchingItems = response.mapItems;
        for (MKMapItem *mapItem in self.matchingItems){
            MKPlacemark *plcMark = mapItem.placemark;
            CLLocation *destinationLoc = [[CLLocation alloc]initWithLatitude:plcMark.coordinate.latitude longitude:plcMark.coordinate.longitude];
            float distanceMeters = (float)[currentLocation distanceFromLocation:destinationLoc];
            float distanceMiles = (float)(distanceMeters / 1609.344);
            ONDUMapAnnotation *annotation = [[ONDUMapAnnotation alloc]initWithTitle:plcMark.name withSubTitle:[NSString stringWithFormat:@"%.1f Miles",distanceMiles] withCoordinate:plcMark.coordinate];
            [self.mapVw addAnnotation:annotation];
        }
    }];
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
