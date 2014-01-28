//
//  OOSMStationInfoViewController.m
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

#import "OOSMStationInfoViewController.h"
#import "OOSMParseHelper.h"
@interface OOSMStationInfoViewController ()
@property(strong, nonatomic)IBOutlet UILabel *titleLable;
@property(strong, nonatomic)OOSMStation *stationToDisplayInfo;
@property(strong, nonatomic)OOSMParseHelper *parseHelper;
@property(strong, nonatomic)NSString *currentStationProperty;
@property(strong, nonatomic)NSArray *sensorProperties;
@property(nonatomic)int currentSensorPropertyIndex;
-(void)addSensorProperties;
@end

@implementation OOSMStationInfoViewController
@synthesize titleLable=_titleLable;
@synthesize stationToDisplayInfo=_stationToDisplayInfo;
@synthesize parseHelper=_parseHelper;
@synthesize currentStationProperty=_currentStationProperty;
@synthesize sensorProperties=_sensorProperties;

-(void)addSensorProperties{

    //set up the parse helper
    
    //on each get request the XML element that holds the result is "ioos:Quantity"
    NSDictionary *elementsForParseHelper = [[NSDictionary alloc] initWithObjectsAndKeys: @"", @"ioos:Quantity", nil];
    
    //make the request correspond to the station we want to view
    NSString *urlString=[@"http://opendap.co-ops.nos.noaa.gov/ioos-dif-sos/SOS?service=SOS&request=GetObservation&version=1.0.0&responseFormat=text/xml;schema=%22ioos/0.6.1%22&observedProperty=**replace**&offering=" stringByAppendingString:self.stationToDisplayInfo.nameForServer];
    
    //submit each value of the sensorProperties property to OOSMParseHelper through changing the URL
    NSURL *urlForParseHelper = [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"**replace**" withString:((NSString*)[self.sensorProperties objectAtIndex:self.currentSensorPropertyIndex])]];
    
    //set up the parser
    self.parseHelper = [[OOSMParseHelper alloc] initWithURL:urlForParseHelper andElementsToRead:elementsForParseHelper];
    self.parseHelper.objectToUpdateForReturnDictionary = self;
    
}

-(void)updateForParseHelperReturnArray:(NSString*)returnString{
    
    //add a lable to the view describing the return String
    UILabel *newSensorPropertyLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    newSensorPropertyLable.text=[[self.currentStationProperty stringByAppendingString:@": " ] stringByAppendingString:returnString];
    newSensorPropertyLable.center=CGPointMake(100, 300+self.currentSensorPropertyIndex*50);
    [newSensorPropertyLable sizeToFit];
    [self.view addSubview:newSensorPropertyLable];
    
    //subtract one in the self.sensor.count because we add one to it in the code.
    if(self.currentSensorPropertyIndex<self.sensorProperties.count-1){
        //add one to currentSensoPropertyIndex.
        self.currentSensorPropertyIndex++;
        
        //change the currentStationProperty
        self.currentStationProperty=(NSString*)[self.sensorProperties objectAtIndex:self.currentSensorPropertyIndex];
        
        //get the new sensor properties
        [self addSensorProperties];
    }
    
}

-(void)setStationInfoToDisplay:(OOSMStation*)stationToDisplay{
    self.stationToDisplayInfo=stationToDisplay;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.titleLable.text=self.stationToDisplayInfo.userReadableName;
    
    //array of all the properties of the station sensors which we want to retrieve
    self.sensorProperties=[[NSArray alloc] initWithObjects:@"air_temperature", @"air_pressure", @"relative_humidity", @"rain_fall", @"visibility",  nil];
    
    self.currentSensorPropertyIndex = 0;
    self.currentStationProperty = (NSString*)[self.sensorProperties objectAtIndex:self.currentSensorPropertyIndex];
    
    [self addSensorProperties];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
