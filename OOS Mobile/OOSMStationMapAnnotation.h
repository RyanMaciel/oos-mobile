//
//  OOSMStationMapAnnotation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
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
#import "OOSMStation.h"
@interface OOSMStationMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *annotationTitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic)int annotationID;
@property (strong, nonatomic)OOSMStation *station;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)c2d;

@end
