//
//  OOSMParseHelper.m
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

#import "OOSMParseHelper.h"
#import "OOSMStationInfoViewController.h"
@interface OOSMParseHelper() <NSXMLParserDelegate>

@property(strong, nonatomic)NSXMLParser *parser;
@property(strong, nonatomic)NSString *currentElement;
@property(strong, nonatomic)NSDictionary *elementsToFind;
@property(strong, nonatomic)NSMutableArray *elementsToReturn;
@property(strong, nonatomic)NSString *stationName;
@property(nonatomic)NSNumber *currentStationSensorPropertyIndex;
@property(nonatomic)BOOL urlIsValid;
@property(nonatomic)BOOL shouldContinueParsing;
@property(strong, nonatomic)NSMutableData *urlConnectData;
@property(strong, nonatomic)NSString *propertyToFind;

-(void)setUpNSURlConnectionWithURL:(NSURL*)URL;
@end

@implementation OOSMParseHelper
@synthesize parser=_parser;
@synthesize currentElement=_currentElement;
@synthesize elementsToFind=_elementsToFind;
@synthesize elementsToReturn=_elementsToReturn;
@synthesize delegate=_delegate;
@synthesize stationName=_stationName;
@synthesize currentStationSensorPropertyIndex=_currentStationSensorPropertyIndex;
@synthesize urlIsValid=_urlIsValid;
@synthesize shouldContinueParsing=_shouldContinueParsing;
@synthesize urlConnectData=_urlConnectData;
@synthesize propertyToFind=_propertyToFind;

-(void)stopParser{
    //stop the parsing
    self.shouldContinueParsing = NO;
    [self.parser abortParsing];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self elementsToReturnChanged];
}

-(void)elementsToReturnChanged{
    //the string to return to the delegate
    NSString *stringForDelegate;
    
    //if self.elementsToReturn is not empty and its content is not @""
    if(self.elementsToReturn.count>0 && ![[self.elementsToReturn objectAtIndex:0] isEqualToString:@""] && self.shouldContinueParsing){
        stringForDelegate = [self.elementsToReturn objectAtIndex:0];
    }
    if(stringForDelegate){
        //call the delegate method on the main thread. To update the GUI
        __weak NSString *weakStringForDelegate = stringForDelegate;
        __weak NSString *weakPropertyForDelegate = self.propertyToFind;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void){
            [self.delegate parseHelperFoundMatchWithReturnString:weakStringForDelegate forProperty:weakPropertyForDelegate];
        }];
    }
    //stop the parsing. it has already returned a value and is no longer needed.
    self.shouldContinueParsing = NO;
    [self.parser abortParsing];
    self.parser = nil;
  
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //get all the keys from the elementsToFind Dictionary
    NSArray *keys = [self.elementsToFind allKeys];
    
    //some Stations don't have certain parameters and the request will be redirected to an ExceptionReport
    if(![elementName isEqualToString:@"ExceptionReport"]){
        
        //if none of the keys in the elementsToFindDictionary are equal to the elementName parameter above then self.current element will not be set, therefore no value will be stored for this element
        for (int i=0; i<keys.count; i++) {
            if ([(NSString*)[keys objectAtIndex:i] isEqualToString:elementName]) {
                //if the element has no specified attribute in the elementsToFindDictionary then set the currentElement to element Name
                if([((NSString*)[self.elementsToFind objectForKey:[keys objectAtIndex:i]]) isEqualToString:@""]){
                    self.currentElement = elementName;
                    
                }
                //[attributeDict objectForKey:[[((NSDictionary*)[self.elementsToFind objectForKey:[keys objectAtIndex:i]]) allKeys] objectAtIndex:0]] gets the value of the key in attributeDict
                //that is equal to the one and only key that should be in the dictionary that is the value of the key in elementsToFind that is equal to the elementName parameter passed to
                //this method.
                //[[self.elementsToFind objectForKey:elementName] objectForKey:[[[self.elementsToFind objectForKey:elementName] allKeys] objectAtIndex:0]] gets the value of the only key in the dictionary which is the value of the
                //self.elementsToFind key elementName
                else if ([attributeDict objectForKey:[[((NSDictionary*)[self.elementsToFind objectForKey:elementName]) allKeys] objectAtIndex:0]] == [[self.elementsToFind objectForKey:elementName] objectForKey:[[[self.elementsToFind objectForKey:elementName] allKeys] objectAtIndex:0]]){
                    self.currentElement = elementName;
                }
            }
        }
    }else{
        //if the XML that we are parsing is an error report we will abort parsing
        [self.parser abortParsing];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //if self.currentElement's value is @"" then the info for this element should not be stored.
    if(![self.currentElement isEqualToString:@""]){
        [self.elementsToReturn addObject:string];
        [self elementsToReturnChanged];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //set current element to @"" so that if the next element's info is not to be stored it won't be.  See the method and comment above.
    self.currentElement = @"";
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error parsing.");
    
    [self elementsToReturnChanged];
}

-(void)setUpNSURlConnectionWithURL:(NSURL *)URL{
    //create a NSURLRequest
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    [self.urlConnectData appendData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error]];
    
    if(error){
        //return nil to the delegate if an error has occured
        [self elementsToReturnChanged];
    }
    
    //allocate and initialize the parser. If it returns nil, then return nil to the delegate
    self.parser = [[NSXMLParser alloc] initWithData:self.urlConnectData];
    
    if(!self.parser){
        [self elementsToReturnChanged];
    }
    
}

//initailize and set up the parser.
-(id)initWithURL:(NSURL*)URL elementsToFind:(NSDictionary *)element stationName:(NSString*)stationName delegate:(id<OOSMParseHelperDelegate>)delegate propertyToFind:(NSString *)property{
    self = [super init];
    if(self){

        self.propertyToFind = property;
        
        //prevents double values from apearing.
        self.shouldContinueParsing = YES;
        self.elementsToFind = element;
        self.elementsToReturn = [[NSMutableArray alloc] init];
        self.currentElement = [[NSString alloc] init];
        self.currentElement=@"";
        self.stationName = stationName;
        self.currentStationSensorPropertyIndex = [[NSNumber alloc] initWithInt:0];
        self.delegate = delegate;
        self.urlConnectData = [[NSMutableData alloc] init];
        
        if(!URL){
            NSLog(@"An invalid url has been passed to OOSMParseHelper");
            self.urlIsValid = NO;
        }else{
            self.urlIsValid = YES;
            [self setUpNSURlConnectionWithURL:URL];
            
            [self.parser setDelegate:self];
            [self.parser setShouldResolveExternalEntities:NO];
            [self.parser parse];
        }
        
    }
    return self;
}

@end
