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
#import "OOSMParseHelperOperation.h"
#import "OOSMWebViewController.h"
#import "OOSMStationPropertyButton.h"

@interface OOSMStationInfoViewController () <OOSMParseOperationDelegate>

@property(strong, nonatomic)IBOutlet UILabel *titleLable;
@property(strong, nonatomic)OOSMStation *stationToDisplayInfo;
@property(strong, nonatomic)OOSMParseHelper *parseHelper;
@property(strong, nonatomic)NSArray *sensorProperties;
@property(nonatomic)int currentSensorPropertyIndex;
@property(nonatomic, readonly)BOOL stationIsAUserFav;
@property(nonatomic)int numberOfCallbacksFromParser;
@property(nonatomic)BOOL recieviedNonNilValueFromParser;
@property(strong, nonatomic)NSOperationQueue *propertyOperationQueue;
@property(nonatomic)BOOL wasinitiatedWithDictionary;
@property(strong, nonatomic)NSString *webViewURL;
@property(strong, nonatomic)NSString *webViewPropertyString;

-(void)addSensorProperties;
-(IBAction)addStationToUserFavorites;
-(void)getChartWithSender:(id)sender;
-(void)setUpChartURLWithTimeInterval:(NSTimeInterval)interval forProperty:(NSString*)property;

//add an IBOutlet to controll the activity indicator
@property(strong, nonatomic)IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation OOSMStationInfoViewController
@synthesize titleLable=_titleLable;
@synthesize stationToDisplayInfo=_stationToDisplayInfo;
@synthesize parseHelper=_parseHelper;
@synthesize sensorProperties=_sensorProperties;
@synthesize stationIsAUserFav=_stationIsAUserFav;
@synthesize activityView=_activityView;
@synthesize numberOfCallbacksFromParser=_numberOfCallbacksFromParser;
@synthesize recieviedNonNilValueFromParser=_recieviedNonNilValueFromParser;
@synthesize webViewURL=_webViewURL;
@synthesize propertyOperationQueue=_propertyOperationQueue;
@synthesize webViewPropertyString=_webViewPropertyString;
@synthesize wasinitiatedWithDictionary=_wasinitiatedWithDictionary;
@synthesize delegate=_delegate;

#pragma mark Handle Displaying Web View
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[OOSMWebViewController class]]){
        OOSMWebViewController *webController = ((OOSMWebViewController*)segue.destinationViewController);
        
        //give the web view its URL
        webController.webViewURL = self.webViewURL;
        
        //tell it what property it is graphing
        webController.propertyToGraph = self.webViewPropertyString;
    }
}

-(void)getChartWithSender:(id)sender{
    
    if([sender isKindOfClass:[OOSMStationPropertyButton class]]){
        NSString *buttonProperty = ((OOSMStationPropertyButton*)sender).propertyString;
        
        //set the property string to tell the web view controller what property it will be displaying
        self.webViewPropertyString = buttonProperty;
        
        [self setUpChartURLWithTimeInterval:-432000 forProperty:buttonProperty];
        
    }
}
-(void)setUpChartURLWithTimeInterval:(NSTimeInterval)interval forProperty:(NSString *)property{
    
    //create a date formatter that will format the date in a way acceptable for the server
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    //this is the basic string for the url
    NSString *webViewString = @"http://opendap.co-ops.nos.noaa.gov/ioos-dif-sos/SOS?service=SOS&request=GetObservation&version=1.0.0&observedProperty=***SensorProperty***&offering=**StationName**&eventTime=***SecondDate***/***FirstDate***&responseFormat=text/csv";
    
    //set the first date in the time series
     webViewString = [webViewString stringByReplacingOccurrencesOfString:@"***FirstDate***" withString:[dateFormat stringFromDate:[NSDate date]]];
    
    NSDate *intervalDifference=[NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]];
    
    //set the second date in the time series
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"***SecondDate***" withString: [dateFormat stringFromDate:intervalDifference]];
    
    //set the station name for the url
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"**StationName**" withString:self.stationToDisplayInfo.nameForServer];
    
    //set the sensor property
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"***SensorProperty***" withString:property];
    self.webViewURL = webViewString;
    
    //perform the segue
    [self performSegueWithIdentifier:@"ChartView" sender:self];
}

//lazily initialize this varible to tell if the station is a user favorite
-(BOOL)stationIsAUserFav{
    
    //dont run the code below if this variable has already been set to yes.
    if(!_stationIsAUserFav){
        
        //get the info from user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *userStationFavorites = [userDefaults arrayForKey:@"kUserFavoriteStations"];
        
        //if the current station is equal to one of the favorite station return yes.
        for (int i=0; i<userStationFavorites.count; i++) {
            if([[userStationFavorites objectAtIndex:i]  isEqual: @{@"Server Name" : self.stationToDisplayInfo.nameForServer, @"User Readable Name" : self.stationToDisplayInfo.userReadableName}]){
                
                //this code will be run if the station is a user favorite station
                //set the "add to favorites" button to have a light grey tint and not to call anything if tapped on.
                self.navigationItem.rightBarButtonItem.enabled = NO;
                
                return YES;
            }
            
        }
        
        //if it is not a user station favorite return no
        return NO;
        
    }else{
        
        //if self.stationIsAUserFav is already YES return YES.
        return YES;
    }
}

-(IBAction)addStationToUserFavorites{
    
    //this code really should not be called if self.stationIsAUserFav. This if statement is a safeguard.
    if(!self.stationIsAUserFav){
        
        //get the info from user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *userStationFavorites = [userDefaults arrayForKey:@"kUserFavoriteStations"];
        
        //create a NSDictionary to hold info about the station
        NSDictionary *stationInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.stationToDisplayInfo.nameForServer, @"Server Name", self.stationToDisplayInfo.userReadableName, @"User Readable Name", nil];
        
        if(userStationFavorites){
            //add stationToDisplayInfo to the array
            NSMutableArray *userStationFavoritesMutable=[userStationFavorites mutableCopy];
            
            [userStationFavoritesMutable addObject:stationInfo];
            userStationFavorites = (NSArray*) userStationFavoritesMutable;
            
        }else{
            //if the userStationFavorites array is == nil then allocate and initialize a new one
            userStationFavorites = [[NSArray alloc] initWithObjects:stationInfo, nil];
        }
        
        [userDefaults setObject:userStationFavorites forKey:@"kUserFavoriteStations"];
        
    }
    //force update self.stationIsAUserFav
    [self stationIsAUserFav];
}
#pragma mark Handle Interaction With Fav Stations


//When the data has already been downloaed and parsed by another view controller, this method lets that other view controller tell the station info view controller which properties it should display.
-(void)displayWithDictionary:(NSDictionary*)stationInfo{
    for (NSString *key in [stationInfo allKeys]) {
        [self parseHelper:nil returnedString:[stationInfo objectForKey:key] forProperty:key];
    }
}
#pragma mark Get and Handle Data

-(void)addSensorProperties{
    
    //set up a NSOperationQueue to do the parsing on a seperate thread
    self.propertyOperationQueue = [[NSOperationQueue alloc] init];
    self.propertyOperationQueue.name = @"Parser Queue";
    
    //set up OOSMParseHelperOperation
    OOSMParseHelperOperation *parseHelperOp=[[OOSMParseHelperOperation alloc] initWithDelegate:self stationName:self.stationToDisplayInfo.nameForServer elementsToFind:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"air_temperature", @"", @"air_pressure", @"", @"relative_humidity", @"", @"rain_fall", @"", @"visibility", @"", @"air_temperature", @"", @"sea_water_electrical_conductivity", @"", @"currents", @"", @"sea_water_salinity", @"", @"water_surface_height_above_reference_datum", @"", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tide", @"", @"sea_water_temperature", @"", @"winds",@"", @"harmonic_constituents", @"", @"datums", nil]];
    
    [parseHelperOp setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.propertyOperationQueue addOperation:parseHelperOp];
}

-(void)parseHelper:(OOSMParseHelper *)parseHelper returnedString:(NSString *)string forProperty:(NSString*)property{
    NSLog(@"Parse Helper returned values to StationInfoViewController");
    self.numberOfCallbacksFromParser++;

    
    //Make sure that returnSting != nil.
    if(string && ![string isEqualToString: @""]){
        
        //if the activity view is still animating and the string is not nil, then stop the activity view
        if(self.activityView.isAnimating && string){
            
            //stop animating the activity view if a value has been returned
            [self.activityView stopAnimating];
        }
        
        self.recieviedNonNilValueFromParser = YES;
        
        //add a button to the view describing the return String
        OOSMStationPropertyButton *newSensorPropertyButton = [OOSMStationPropertyButton buttonWithType:UIButtonTypeSystem];
        newSensorPropertyButton.frame = CGRectMake(0, 0, 300, 17);
        [newSensorPropertyButton setTitle:[[[property stringByReplacingOccurrencesOfString:@"_" withString:@" "] stringByAppendingString:@": "] stringByAppendingString:string] forState:UIControlStateNormal];
        newSensorPropertyButton.center=CGPointMake(10 + newSensorPropertyButton.frame.size.width/2, 200+self.currentSensorPropertyIndex*25);
        newSensorPropertyButton.propertyString = property;
        [newSensorPropertyButton addTarget:self action:@selector(getChartWithSender:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:newSensorPropertyButton];
        
        
        //subtract one in the self.sensor.count because we add one to it in the code below.
        if(self.currentSensorPropertyIndex<self.sensorProperties.count-1){
            //add one to currentSensoPropertyIndex.
            self.currentSensorPropertyIndex++;
            
        }
    }else{
        NSLog(@"Got a nil value.");
        NSLog(@"number of callbacks from Parse Helper Operation: %d", self.numberOfCallbacksFromParser);
        
        //this code will run if no values were found for the station
        if(self.numberOfCallbacksFromParser>=self.sensorProperties.count-1 && !self.recieviedNonNilValueFromParser){
            
            //stop the activity view
            if(self.activityView.isAnimating){
                [self.activityView stopAnimating];
            }
            
            //add a warning label
            UILabel *newLable = [[UILabel alloc] init];
            newLable.text = @"No values where found for this station";
            [newLable sizeToFit];
            newLable.center = self.view.center;
            
            [self.view addSubview:newLable];
        }
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
        self.recieviedNonNilValueFromParser = NO;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    //when the view will disappear the data parsing should be stopped
    [self.propertyOperationQueue cancelAllOperations];
}
- (void)viewDidLoad
{
    //don't do anything if the userReadableName and the name for the server are both not nil
    if(self.stationToDisplayInfo.userReadableName && self.stationToDisplayInfo.nameForServer){
        if(!self.wasinitiatedWithDictionary){
            //start the activity view animation:
            [self.activityView startAnimating];
            self.activityView.hidesWhenStopped = YES;
            
            //update self.stationIsAUserFav
            [self stationIsAUserFav];
            
            self.titleLable.text=self.stationToDisplayInfo.userReadableName;
            
            //array of all the properties of the station sensors which we want to retrieve
            self.sensorProperties=[[NSArray alloc] initWithObjects:@"air_temperature", @"air_pressure", @"relative_humidity", @"rain_fall", @"visibility", @"air_temperature", @"sea_water_electrical_conductivity", @"currents", @"sea_water_salinity", @"water_surface_height_above_reference_datum", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tide", @"sea_water_temperature", @"winds", @"harmonic_constituents", @"datums",  nil];
            
            self.currentSensorPropertyIndex = 0;
            
            
            [self addSensorProperties];
        }
        
    }else{
        //This handles an error in which the user taps on a station that does not have both the user readable name and the name for the server.
        
        //stop the activity view.
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        
        //move the title label and display a error message.
        self.titleLable.center = self.view.center;
        self.titleLable.text = @"An error has occured.";
        
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
