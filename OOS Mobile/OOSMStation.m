//
//  OOSMStation.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/17/13.
//
//Copyright (c) 2013 RPS ASA. All rights reserved.

//This file is part of OOS Mobile
//OOS Mobile is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    OOS Mobile is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
