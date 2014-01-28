//
//  OOSMStation.m
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

#import "OOSMStation.h"

@implementation OOSMStation
@synthesize location=_location;
@synthesize userReadableName=_userReadableName;
@synthesize nameForServer=_nameForServer;

-(id)initWithUserReadableName:(NSString *)name nameForServer:(NSString *)nameForServer location:(CLLocation *)location{
    self = [super init];
    if(self){
        //set up properties
        self.userReadableName=name;
        
        //fixes a formatting issue
        self.nameForServer=[nameForServer stringByReplacingOccurrencesOfString:@"\n        " withString:@""];
        self.location=location;
    }
    return self;
}

@end
