//
//  OOSMMapViewController.m
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

#import "OOSMMapViewController.h"
#import "OOSMStationMapAnnotation.h"
#import "OOSMStation.h"
#import "OOSMStationInfoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "OOSMDataHandlerModel.h"

@interface OOSMMapViewController () <OOSMDataHandelerDelegate>

@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)OOSMDataHandlerModel *dataHandlerModel;
@property(strong, nonatomic)OOSMStationMapAnnotation *tappedMapAnnotation;
@property(strong, nonatomic)CLLocationManager *coreLocationManager;
@property(strong, nonatomic)UIImage *pinImage;
-(void)createMap;

@end

@implementation OOSMMapViewController
@synthesize mapView=_mapView;
@synthesize dataHandlerModel=_dataHandlerModel;
@synthesize tappedMapAnnotation=_tappedMapAnnotation;
@synthesize coreLocationManager=_coreLocationManager;
@synthesize pinImage=_pinImage;

-(void)datatHandlerFoundStation:(OOSMStation *)station{
    
    CLLocation *stationLocation=station.location;
    
    OOSMStationMapAnnotation *newMapAnnotation=[[OOSMStationMapAnnotation alloc] initWithTitle:@"" andCoordinate:stationLocation.coordinate];
    newMapAnnotation.station=station;
    [self.mapView addAnnotation:newMapAnnotation];
}
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    //reuse a new MKAnnotationView if one cannot be reused
    static NSString *viewIdentifier = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
    
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
    }
    
    //give the annotation a custom image
    annotationView.image = self.pinImage;

    annotationView.frame = CGRectMake(0, 0, 30, 30);
    return annotationView;
}

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

-(void)createMap{
    self.pinImage = [UIImage imageNamed:@"blue_buoy_icon_test.png"];
    self.mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate=self;
    
    MKCoordinateRegion regionToFocusOn=[self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(42, -70), 10000000, 10000000)];
    [self.mapView setRegion:regionToFocusOn];
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
    [self createMap];
    OOSMDataHandlerModel *dataHandlerModel=[[OOSMDataHandlerModel alloc] init];
    dataHandlerModel.delegate = self;
    
    self.coreLocationManager=[[CLLocationManager alloc] init];
    self.coreLocationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.coreLocationManager.distanceFilter=kCLDistanceFilterNone;
    [self.coreLocationManager startUpdatingLocation];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
