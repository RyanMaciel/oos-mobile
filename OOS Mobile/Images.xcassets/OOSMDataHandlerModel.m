//
//  OOSMDataHandlerModel.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "OOSMDataHandlerModel.h"
@interface OOSMDataHandlerModel()
-(void)getData;
-(CLLocation*)getStationCoordinates;

@property(strong, nonatomic)NSXMLParser *parser;
@property(strong, nonatomic)NSMutableDictionary *stationsToDisplay;
@property(strong, nonatomic)NSString *currentRSSElement;
@property(strong, nonatomic)NSMutableString *stationName;
@property(strong, nonatomic)NSMutableString *stationLatitudeLongitude;

@end

@implementation OOSMDataHandlerModel
@synthesize parser=_parser;
@synthesize stationsToDisplay=_stationsToDisplay;
@synthesize currentRSSElement=_currentRSSElement;
@synthesize stationName=_stationName;
@synthesize stationLatitudeLongitude=_stationLatitudeLongitude;


//returns all of the stations from the XML
-(NSArray*)getAllStations{
    return [self.stationsToDisplay allValues];
}

-(CLLocation*)getStationCoordinates{
    
      NSArray *separatedCoordinateComponents=[self.stationLatitudeLongitude componentsSeparatedByString:@", "];
    
    NSString *stationLatitude;
    NSString *stationLongitude;
    if(separatedCoordinateComponents.count==2){
        stationLatitude=[separatedCoordinateComponents objectAtIndex:0];
        stationLongitude=[separatedCoordinateComponents objectAtIndex:1];
    }
    CLLocation *location=[[CLLocation alloc] initWithLatitude:[stationLatitude floatValue] longitude:[stationLongitude floatValue]];
    return location;
}

-(void)setCurrentRSSElement:(NSString *)currentRSSElement{
    if((![_currentRSSElement isEqualToString:currentRSSElement]) && (!([_currentRSSElement isEqualToString:@"sos:ObservationOffering"] && [currentRSSElement isEqualToString:@"gml:lowerCorner"]))){
        
        NSDictionary *newStationDataDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:self.stationName, @"kStationName", [self getStationCoordinates], @"kStationLocation", nil];
        
        [self.stationsToDisplay setObject:newStationDataDictionary forKey:self.stationName];
        
        self.stationName=nil;
        self.stationName=[[NSMutableString alloc] init];
        
        self.stationLatitudeLongitude=nil;
        self.stationLatitudeLongitude=[[NSMutableString alloc] init];
        _currentRSSElement=currentRSSElement;

    }
    
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
    if([self.currentRSSElement isEqualToString:@"gml:description"]){
        [self.stationName appendString:string];
        
    }
    if([self.currentRSSElement isEqualToString:@"gml:lowerCorner"]){
        [self.stationLatitudeLongitude appendString:string];
    }
}

-(void)getData{
    NSURL *feedURL=[NSURL URLWithString:@"file:///Users/ryanmaciel/test/get_caps.xml"];
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
