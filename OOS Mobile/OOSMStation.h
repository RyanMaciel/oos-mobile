//
//  OOSMStation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/17/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface OOSMStation : NSObject

-(void)setLocation:(CLLocation*)stationLocation;
-(void)setName:(NSString*)stationName;
-(CLLocation*)getStationLocation;
-(NSString*)getName;
-(id)initWithName:(NSString*)name location:(CLLocation*)location;
@end
