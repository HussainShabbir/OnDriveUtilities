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
-(id)initWithTitle: (NSString*)title  withLocationName: (NSString*)locationName withDiscipline: (NSString*)discipline withCoordinate: (CLLocationCoordinate2D)mapCoordinate{
    self.title = title;
    self.locationName = locationName;
    self.discipline = discipline;
    self.coordinate = mapCoordinate;
    return self;
}

-(NSString*)subtitle{
    return self.locationName;
}

-(MKMapItem *)mapItem{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:@{CNPostalAddressStreetKey : self.title}];
    MKMapItem *mapItm = [[MKMapItem alloc]initWithPlacemark:placemark];
    return mapItm;
}


@end
