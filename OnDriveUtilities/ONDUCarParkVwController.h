//
//  ONDUCarParkVwController.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface ONDUCarParkVwController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,weak) IBOutlet MKMapView *map;
@end
