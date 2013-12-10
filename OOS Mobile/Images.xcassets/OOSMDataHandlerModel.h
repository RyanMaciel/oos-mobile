//
//  OOSMDataHandlerModel.h
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OOSMDataHandlerModel : NSObject <NSXMLParserDelegate>

-(NSDictionary*)getDataForStationName:(NSString*)stationName;
-(NSArray*)getAllStations;
@end
