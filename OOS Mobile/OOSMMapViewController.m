//
//  OOSMMapViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//

#import "OOSMMapViewController.h"
#import <MapKit/MapKit.h>
#import "OOSMStationMapAnnotation.h"
#import "OOSMDataHandlerModel.h"

@interface OOSMMapViewController ()
@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)OOSMDataHandlerModel *dataHandlerModel;

-(void)populateMap;

@end

@implementation OOSMMapViewController
@synthesize mapView=_mapView;
@synthesize dataHandlerModel=_dataHandlerModel;

-(void)populateMap{
    self.mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSArray *allStations=[self.dataHandlerModel getAllStations];
    for(int i=0; i<allStations.count; i++){
        CLLocation *stationLocation=[[allStations objectAtIndex:i] objectForKey:@"kStationLocation"];
        
        OOSMStationMapAnnotation *newMapAnnotation=[[OOSMStationMapAnnotation alloc] initWithTitle:@"" andCoordinate:stationLocation.coordinate];
        
        [self.mapView addAnnotation:newMapAnnotation];
    }
    [self.view addSubview:self.mapView];

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
    self.dataHandlerModel=[[OOSMDataHandlerModel alloc] init];
    [self populateMap];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
