//
//  OOSMDataHandlerModel.m
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

#import <MapKit/MapKit.h>
#import "OOSMDataHandlerModel.h"
#import "OOSMStation.h"

@interface OOSMDataHandlerModel()
-(void)getData;
-(CLLocation*)getStationCoordinates;

@property(strong, nonatomic)NSXMLParser *parser;
@property(strong, nonatomic)NSMutableDictionary *stationsToDisplay;
@property(strong, nonatomic)NSString *currentRSSElement;
@property(strong, nonatomic)NSMutableString *stationName;
@property(strong, nonatomic)NSMutableString *stationLatitudeLongitude;
@property(strong, nonatomic)NSMutableString *stationNameForServer;
@end

@implementation OOSMDataHandlerModel
@synthesize parser=_parser;
@synthesize stationsToDisplay=_stationsToDisplay;
@synthesize currentRSSElement=_currentRSSElement;
@synthesize stationName=_stationName;
@synthesize stationLatitudeLongitude=_stationLatitudeLongitude;
@synthesize stationNameForServer=_stationNameForServer;

//returns all of the stations from the XML
-(NSArray*)getAllStations{
    return [self.stationsToDisplay allValues];
}

-(CLLocation*)getStationCoordinates{
    
    //should separate the coordinates into to string components
    NSArray *separatedCoordinateComponents=[self.stationLatitudeLongitude componentsSeparatedByString:@" "];
    
    //define the component strings
    NSString *stationLatitude;
    NSString *stationLongitude;
    
    //if the [self.stationLatitudeLongitude componentsSeparatedByString:@" "] didn't work then do nothing
    if(separatedCoordinateComponents.count>1){
        
        //set the component strings
        stationLatitude=[separatedCoordinateComponents objectAtIndex:0];
        stationLongitude=[separatedCoordinateComponents objectAtIndex:1];
        
        //remove some formatting that often appears
        [stationLatitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [stationLongitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    }
    
    //make sure the coordinates are valid on the coordinate grid.
    if([stationLatitude floatValue]>=-90 && [stationLatitude floatValue]<=90 && [stationLongitude floatValue]>-180 && [stationLongitude floatValue]<180){
        //stores the values of the two strings into a CLLocation object
        CLLocation *location=[[CLLocation alloc] initWithLatitude:[stationLatitude floatValue] longitude:[stationLongitude floatValue]];
        return location;
    }
    //returns nil if the coordinates weren't formatted properly.
    return nil;
}

-(void)setCurrentRSSElement:(NSString *)currentRSSElement{
    //make sure that all the values for the station are not empty strings.
    if((![self.stationName isEqualToString:@""]) && (![self.stationLatitudeLongitude isEqualToString:@""] && (![self.stationNameForServer isEqualToString:@""]))){
        
        //makes sure that the value of currentRSSElement is in fact being changed to a different value and that currentRSSElement isn't being changed from sos:ObservationOffering to gml:lowerCorner
        if((![_currentRSSElement isEqualToString:currentRSSElement]) && (!([_currentRSSElement isEqualToString:@"sos:ObservationOffering"] && [currentRSSElement isEqualToString:@"gml:lowerCorner"]))){
            //allocate and initialize the newStation
            OOSMStation *newStation=[[OOSMStation alloc] initWithUserReadableName:self.stationName nameForServer:self.stationNameForServer location:[self getStationCoordinates]];
            
            //add a new station to the station dictionary
            [self.stationsToDisplay setObject:newStation forKey:self.stationName];
            
            //resets the stationName, stationLatitudeLongitude and stationNameForServer properties for the next stations
            self.stationName=nil;
            self.stationName=[[NSMutableString alloc] init];
            
            self.stationLatitudeLongitude=nil;
            self.stationLatitudeLongitude=[[NSMutableString alloc] init];
            
            self.stationNameForServer=nil;
            self.stationNameForServer = [[NSMutableString alloc] init];
        }
    }
    //changes the currentRSSElement variable
    _currentRSSElement=currentRSSElement;

}
-(NSDictionary*)getDataForStationName:(NSString *)stationName{
    [self getData];
    @try{
        return ((NSDictionary*)[self.stationsToDisplay objectForKey:stationName]);
    }
    @catch (NSException*) {
        return nil;
    }
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.currentRSSElement=elementName;
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //gets the data from the xml and stores it in the appropriate properties
    if([self.currentRSSElement isEqualToString:@"gml:description"]){
        [self.stationName appendString:string];
        
    }
    if([self.currentRSSElement isEqualToString:@"gml:lowerCorner"]){
        [self.stationLatitudeLongitude appendString:string];
    }
    if([self.currentRSSElement isEqualToString:@"gml:name"]){
        [self.stationNameForServer appendString:string];
    }
}

-(void)getData{
    NSURL *feedURL=[NSURL URLWithString:@"http://opendap.co-ops.nos.noaa.gov/ioos-dif-sos/SOS?service=SOS&request=GetCapabilities&version=1.0.0"];
    self.parser=[[NSXMLParser alloc] initWithContentsOfURL:feedURL];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
}
-(id)init{
    self=[super init];
    if(self){
        self.stationName=[[NSMutableString alloc] init];
        self.stationLatitudeLongitude=[[NSMutableString alloc] init];
        self.stationsToDisplay=[[NSMutableDictionary alloc] init];
        [self getData];
    
    }
    return self;
}
@end
