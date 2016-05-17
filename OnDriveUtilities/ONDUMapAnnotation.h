//
//  ONDUMapAnnotation.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ONDUMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic,copy) NSString *title;
//@property (nonatomic,copy) NSString *locationName;
//@property (nonatomic,copy) NSString *discipline;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
//-(id)initWithTitle: (NSString*)title  withLocationName: (NSString*)locationName withDiscipline: (NSString*)discipline withCoordinate: (CLLocationCoordinate2D)mapCoordinate;
//-(MKMapItem *)mapItem;
-(id)initWithTitle : (NSString*)title withCoordinate: (CLLocationCoordinate2D)mapCoordinate;


@end
