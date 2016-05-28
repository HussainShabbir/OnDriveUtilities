//
//  ONDUMapAnnotation.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ONDUMapAnnotation : NSObject<MKAnnotation,NSCoding>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,strong) NSString *locationName;
@property (nonatomic,strong) MKPlacemark *placeMark;
//@property (nonatomic,copy) NSString *discipline;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
//-(id)initWithTitle: (NSString*)title  withLocationName: (NSString*)locationName withDiscipline: (NSString*)discipline withCoordinate: (CLLocationCoordinate2D)mapCoordinate;
-(MKMapItem *)mapItem;

-(id)initWithTitle: (NSString*)title withSubTitle: (NSString*)subtitle withCoordinate: (CLLocationCoordinate2D)mapCoordinate withPlaceMarkTitle:(NSString*)placeMarkTitle andLocationName:(NSString*)location;

-(BOOL)isLocationAvailable:(NSArray*)locations;
@end
