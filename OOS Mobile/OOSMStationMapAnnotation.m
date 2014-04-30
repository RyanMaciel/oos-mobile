//
//  OOSMStationMapAnnotation.m
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

#import "OOSMStationMapAnnotation.h"

@implementation OOSMStationMapAnnotation
@synthesize coordinate=_coordinate;
@synthesize annotationID=_annotationID;
@synthesize station=_station;
@synthesize clusteredAnnotations=_clusteredAnnotations;
@synthesize isACluster=_isACluster;
@synthesize numberOfStations=_numberOfStations;

-(void)setIsACluster:(BOOL)isACluster{
    _isACluster = isACluster;
    
    //if the annotation is a cluster then make sure that self.clusteredAnnotations is initialized
    if(!self.clusteredAnnotations){
        self.clusteredAnnotations = [[NSMutableArray alloc] init];
    }
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)c2d{
    self=[super init];
    if(self){
        _coordinate=c2d;
    }
    return self;
}
@end
