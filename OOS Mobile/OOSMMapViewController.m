//
//  OOSMMapViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/10/13.
//  
//Copyright (c) 2013 RPS ASA. All rights reserved.

//This file is part of OOS Mobile
//OOS Mobile is free software: you can redistribute it and/or modify
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

#import "OOSMMapViewController.h"
#import "OOSMStationMapAnnotation.h"
#import "OOSMDataHandlerModel.h"
#import "OOSMStation.h"
#import "OOSMStationInfoViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface OOSMMapViewController ()

@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)OOSMDataHandlerModel *dataHandlerModel;
@property(strong, nonatomic)OOSMStationMapAnnotation *tappedMapAnnotation;
@property(strong, nonatomic)CLLocationManager *coreLocationManager;
-(void)populateMap;

@end

@implementation OOSMMapViewController
@synthesize mapView=_mapView;
@synthesize dataHandlerModel=_dataHandlerModel;
@synthesize tappedMapAnnotation=_tappedMapAnnotation;
@synthesize coreLocationManager=_coreLocationManager;

//handle touches on the annotations
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[OOSMStationMapAnnotation class]]){
        self.tappedMapAnnotation=(OOSMStationMapAnnotation*)(view.annotation);
        [self performSegueWithIdentifier:@"StationInfo" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.destinationViewController respondsToSelector:@selector(setStationInfoToDisplay:)]){
        
        //provide the OOSMStationInfoViewController with the information it needs.
        OOSMStationInfoViewController *destinationViewController=segue.destinationViewController;
        [destinationViewController setStationInfoToDisplay:self.tappedMapAnnotation.station];
    }
}

-(void)populateMap{
    self.mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate=self;
    
    MKCoordinateRegion regionToFocusOn=[self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(self.coreLocationManager.location.coordinate, 1000, 1000)];
    [self.mapView setRegion:regionToFocusOn];
    
    NSArray *allStations=[self.dataHandlerModel getAllStations];
    for(int i=0; i<allStations.count; i++){
        CLLocation *stationLocation=[(OOSMStation*)[allStations objectAtIndex:i] getStationLocation];
        
        OOSMStationMapAnnotation *newMapAnnotation=[[OOSMStationMapAnnotation alloc] initWithTitle:@"" andCoordinate:stationLocation.coordinate];
        newMapAnnotation.station=[allStations objectAtIndex:i];
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
    
    self.coreLocationManager=[[CLLocationManager alloc] init];
    self.coreLocationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.coreLocationManager.distanceFilter=kCLDistanceFilterNone;
    [self.coreLocationManager startUpdatingLocation];
    
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
