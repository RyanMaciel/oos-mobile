//
//  OOSMStationMapAnnotation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OOSMStationMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *annotationTitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic)int annotationID;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)c2d;

@end
