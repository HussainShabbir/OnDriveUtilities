//
//  ONDUCarParkVwController.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface ONDUCarParkVwController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet MKMapView *map;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end
