//
//  OOSMParseHelperOperation.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 1/7/14.
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

#import <Foundation/Foundation.h>
@protocol OOSMParseOperationDelegate <NSObject>

//return the string found from the XML to the delgate or nil if nothing was found
-(void)parseHelper:(OOSMParseHelper*)parseHelper
    returnedString:(NSString*)string
       forProperty:(NSString*)property;
@end

@interface OOSMParseHelperOperation : NSOperation
@property(nonatomic, assign) id <OOSMParseOperationDelegate> delegate;
-(id)initWithDelegate:(id<OOSMParseOperationDelegate>)delegate stationName:(NSString*)stationName elementsToFind:(NSDictionary*)elementsToFind;

@end

