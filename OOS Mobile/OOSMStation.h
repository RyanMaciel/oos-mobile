//
//  OOSMStation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/17/13.
//
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//
//  This file is part of OOS Mobile
//  OOS Mobile is free software: you can redistribute it and/or modify
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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OOSMMapPoint.h"

@interface OOSMStation : NSObject

@property(strong, nonatomic)NSString *nameForServer;
@property(strong, nonatomic)NSString *userReadableName;
@property(strong, nonatomic)CLLocation *location;
@property(strong, nonatomic)NSString *serverid;

//get a point with the same id as the station
-(OOSMMapPoint*)getPoint;

-(id)initWithUserReadableName:(NSString*)name nameForServer:(NSString*)nameForServer location:(CLLocation*)location;

-(NSArray*)unwrappedStation;
-(id)initWithUnwrappedStation:(NSArray*)unwrappedStation;
@end
