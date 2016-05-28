//
//  ONDUMapAnnotation.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUMapAnnotation.h"
#import <Contacts/Contacts.h>

@implementation ONDUMapAnnotation
//-(id)initWithTitle: (NSString*)title  withLocationName: (NSString*)locationName withDiscipline: (NSString*)discipline withCoordinate: (CLLocationCoordinate2D)mapCoordinate{
//    self.title = title;
//    self.locationName = locationName;
//    self.discipline = discipline;
//    self.coordinate = mapCoordinate;
//    return self;
//}

//-(NSString*)subtitle{
//    return self.locationName;
//}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_subtitle forKey:@"subtitle"];
    [aCoder encodeObject:_placeMark forKey:@"placeMark"];
    [aCoder encodeObject:_locationName forKey:@"locationName"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self)
    {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        _placeMark = [aDecoder decodeObjectForKey:@"placeMark"];
        _locationName = [aDecoder decodeObjectForKey:@"locationName"];
    }
    return self;
}



-(MKMapItem *)mapItem{
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:@{CNPostalAddressStreetKey : self.title}];
    MKMapItem *mapItm = [[MKMapItem alloc]initWithPlacemark:self.placeMark];
    return mapItm;
}

-(id)initWithTitle: (NSString*)title withSubTitle: (NSString*)subtitle withCoordinate: (CLLocationCoordinate2D)mapCoordinate withPlaceMarkTitle:(NSString*)placeMarkTitle andLocationName:(NSString*)location{
    self.title = title;
    self.subtitle = subtitle;
    self.coordinate = mapCoordinate;
    self.placeMark = [[MKPlacemark alloc]initWithCoordinate:mapCoordinate addressDictionary:@{CNPostalAddressStreetKey : placeMarkTitle}];
    self.locationName = location;
    return self;
}

-(BOOL)isLocationAvailable:(NSArray*)locations
{
    BOOL isExist = NO;
    for (ONDUMapAnnotation *location in locations){
        if ([self.locationName isEqualToString:location.locationName]){
            isExist = YES;
            break;
        }
    }
    return isExist;
}

@end
