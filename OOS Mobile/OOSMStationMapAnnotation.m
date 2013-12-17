//
//  OOSMStationMapAnnotation.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//
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
