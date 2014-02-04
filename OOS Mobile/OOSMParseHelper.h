//
//  OOSMParseHelper.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/30/13.
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


//This class is meant to help with the parsing of RSS feeds. The initWithURL:andElementsToRead: method should be called. The class will then parse the RSS from the URL given and store the value of each element which the element parameter passed to the initializer method mentioned above in the property elementsToReturn.

//the NSDictionary recieved as a parameter of this initializer method should be formatted so the the key is the element name to find and the value is another NSDictionary whose single key will be the element's attribute, and single
//value will be the attribute's value.
//if no attribute is meant to be specified the value for the key should be set to and empty string (@"")

#import <Foundation/Foundation.h>

@protocol OOSMParseHelperDelegate;
@protocol OOSMParseHelperOperationDelegate;

@interface OOSMParseHelper : NSObject


-(id)initWithURL:(NSURL*)URL elementsToFind:(NSDictionary *)element stationName:(NSString*)stationName;

//the parsing will not start until this property is set.
@property (nonatomic, assign) id <OOSMParseHelperDelegate> delegate;
@property (nonatomic, assign) id <OOSMParseHelperOperationDelegate> operationDelegate;

@end

@protocol OOSMParseHelperDelegate <NSObject>

//This method will inform the delegate when a string has been found from the XML. The delegate should be able to handle a nil value for the returnString Parameter
-(void)parseHelperFoundMatch:(OOSMParseHelper *)parseHelper withReturnString:(NSString*)returnString;

@end

@protocol OOSMParseHelperOperationDelegate <NSObject>

-(void)parseHelperFinished;

@end
