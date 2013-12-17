//
//  OOSMStationMapAnnotation.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import "OOSMStationMapAnnotation.h"

@implementation OOSMStationMapAnnotation
@synthesize coordinate=_coordinate;
@synthesize annotationTitle=_annotationTitle;
@synthesize annotationID=_annotationID;
@synthesize station=_station;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)c2d{
    self=[super init];
    if(self){
        _annotationTitle=title;
        _coordinate=c2d;
    }
    return self;
}
@end
