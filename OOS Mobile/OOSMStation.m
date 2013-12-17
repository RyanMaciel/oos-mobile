//
//  OOSMStation.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/17/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import "OOSMStation.h"
@interface OOSMStation()
@property(strong, nonatomic)CLLocation *stationLocation;
@property(strong, nonatomic)NSString *stationName;
@end

@implementation OOSMStation

-(CLLocation*)getStationLocation{
    return self.stationLocation;
}

-(NSString*)getName{
    return self.stationName;
}

-(void)setLocation:(CLLocation*)stationLocation{
    self.stationLocation=stationLocation;
}

-(void)setName:(NSString*)stationName{
    self.stationName=stationName;
}

-(id)initWithName:(NSString *)name location:(CLLocation *)location{
    self = [super init];
    if(self){
        self.stationName=name;
        self.stationLocation=location;
    }
    return self;
}

@end
