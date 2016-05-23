//
//  ONDUTransitViewcontroller.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/22/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ONDUTransitViewcontroller : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,weak) IBOutlet MKMapView *mapVw;
@property (nonatomic,strong) NSString *selectedTransit;
@end
