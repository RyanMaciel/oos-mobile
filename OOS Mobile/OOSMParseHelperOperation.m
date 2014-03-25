//
//  OOSMParseHelperOperation.m
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

#import "OOSMParseHelper.h"
#import "OOSMParseHelperOperation.h"
@interface OOSMParseHelperOperation () <OOSMParseHelperDelegate>{
    BOOL executing;
    BOOL finished;

}
@property(strong, nonatomic)NSString *stationName;
@property(strong, nonatomic)NSDictionary *elementsForParseHelper;
@property(nonatomic)int propertyNumber;
@property(strong, nonatomic)NSString *stringForNextCallback;
@property(strong, nonatomic)OOSMParseHelper *parseHelperForNextCallback;

-(void)getNextProperty;
-(void)finishedOperation;
-(void)callbackToDelegateWithString:(NSString*)string property:(NSString*)property;
@end

@implementation OOSMParseHelperOperation

@synthesize elementsForParseHelper=_elementsForParseHelper;
@synthesize stationName=_stationName;
@synthesize propertyNumber=_propertyNumber;
@synthesize stringForNextCallback=_stringForNextCallback;
@synthesize parseHelperForNextCallback=_parseHelperForNextCallback;

//return info to the delgate
-(void)callbackToDelegateWithString:(NSString*)string property:(NSString*)property{
    //don't return anything if the operation is cancelled
    if(!self.isCancelled){
        [self.delegate parseHelper:self.parseHelperForNextCallback returnedString:string forProperty:property];
    }
}

//callback from the OOSMParseHelper
-(void)parseHelperFoundMatchWithReturnString:(NSString *)returnString forProperty:(NSString *)property{
    NSLog(@"OOSMParseOperation recieved callback from OOSMParseHeler");
    self.stringForNextCallback = returnString;
    [self callbackToDelegateWithString:returnString property:property];

}

-(void)parseHelperFinished{
    self.stringForNextCallback = nil;
    self.parseHelperForNextCallback = nil;
    
    self.propertyNumber++;
    if(self.propertyNumber<[self.elementsForParseHelper allKeys].count && !self.isCancelled){
        [self getNextProperty];
    }
}

-(BOOL)isExecuting{
    return executing;
}
-(BOOL)isFinished{
    return finished;
}

//call when the operation is finished
-(void)finishedOperation{
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    
}

-(BOOL)isConcurrent{
    return YES;
}

-(void)getNextProperty{
    
    
    //submit each value of the sensorProperties property to OOSMParseHelper through changing the URL
    NSURL *urlForParseHelper = [[NSURL alloc] initWithString:[[@"http://opendap.co-ops.nos.noaa.gov/ioos-dif-sos/SOS?service=SOS&request=GetObservation&version=1.0.0&observedProperty=*PropertyObserved*&offering=StationName&responseFormat=text/xml;schema=%22ioos/0.6.1%22" stringByReplacingOccurrencesOfString:@"StationName" withString:self.stationName] stringByReplacingOccurrencesOfString:@"*PropertyObserved*" withString:[[self.elementsForParseHelper allKeys] objectAtIndex:self.propertyNumber]]];
    
    //this might cause an exception
    @try {
        //set up the parser and give one of the key/value pairs in self.elementsForParseHelper for its elements to find
        OOSMParseHelper *helper=[[OOSMParseHelper alloc] initWithURL:urlForParseHelper elementsToFind:[[NSDictionary alloc ] initWithObjectsAndKeys:[self.elementsForParseHelper objectForKey:[[self.elementsForParseHelper allKeys] objectAtIndex:self.propertyNumber]], @"ioos:Quantity", nil] stationName:self.stationName delegate:self propertyToFind:[[self.elementsForParseHelper allKeys] objectAtIndex:self.propertyNumber]];
        self.parseHelperForNextCallback = helper;
    }
    @catch (NSException *exception) {
        //call back to the delegate
        [self callbackToDelegateWithString:nil property:nil];
    }
    @finally {
        //continue execution
        [self parseHelperFinished];
    }
    
    //this will do the above again until all of the properties have parse helper objects working on them.
    [self parseHelperFinished];
}
-(id)initWithDelegate:(id<OOSMParseOperationDelegate>)delegate stationName:(NSString *)stationName elementsToFind:(NSDictionary *)elementsToFind{
    
    self = [super init];
    if(self){
        self.delegate = delegate;
        self.elementsForParseHelper = elementsToFind;
        self.stationName = stationName;
    }
    return self;
}
-(void)start{
    
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self getNextProperty];
}



@end
