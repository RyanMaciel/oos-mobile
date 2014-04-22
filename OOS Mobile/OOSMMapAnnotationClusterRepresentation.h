//
//  OOSMMapAnnotationClusterRepresentation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 3/26/14.
//  Copyright (c) 2014 RPS ASA. All rights reserved.
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

//This class is not meant to be used on its own. Instead, one of its subclasses should be used. The purpose of this class is to make it easier to convert the clusters and positions to annotations
//on the map view. The only property that is used by that process is the position, which it can use without having to know which subclass is actually being converted.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OOSMMapAnnotationClusterRepresentation : NSObject
@property(nonatomic)CLLocationCoordinate2D position;
@end
