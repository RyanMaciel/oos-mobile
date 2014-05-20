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
#import "OOSMMapCluster.h"
#import "OOSMMapPoint.h"
#import "OOSMClusterModel.h"

@interface OOSMMapViewController () <OOSMDataHandelerDelegate, MKMapViewDelegate>

@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)OOSMDataHandlerModel *dataHandlerModel;
@property(strong, nonatomic)OOSMStationMapAnnotation *tappedMapAnnotation;
@property(strong, nonatomic)CLLocationManager *coreLocationManager;
@property(strong, nonatomic)UIImage *defaultPinImage;
@property(strong, nonatomic)UIImage *fiftyPlusPinImage;
@property(strong, nonatomic)UIImage *oneHundredPlusPinImage;
@property(strong, nonatomic)UIImage *fiveHundredPlusPinImage;
-(void)createMap;

-(void)handleClustering;
-(void)addClustersToMap:(NSArray*)clusters;
-(void)addStationsPointsToMap:(NSDictionary*)stationPoints;
-(void)addStationToMap:(OOSMStation*)station;

//this will be an array of OOSMStations to referece to--among other things--cluster the pins on the map
@property(strong, nonatomic)NSMutableDictionary *stations;

//this will be an array of OOSMMapPoins to reference when clustering the pins on the map.
@property(strong, nonatomic)NSMutableDictionary *stationPoints;
@property(strong, nonatomic)OOSMClusterModel *clusterModel;

@end

@implementation OOSMMapViewController
@synthesize mapView=_mapView;
@synthesize dataHandlerModel=_dataHandlerModel;
@synthesize tappedMapAnnotation=_tappedMapAnnotation;
@synthesize coreLocationManager=_coreLocationManager;
@synthesize defaultPinImage=_defaultPinImage;
@synthesize mapDelegate=_mapDelegate;
@synthesize stations=_stations;
@synthesize stationPoints=_stationPoints;
@synthesize clusterModel=_clusterModel;
@synthesize fiftyPlusPinImage=_fiftyPlusPinImage;
@synthesize oneHundredPlusPinImage=_oneHundredPlusPinImage;
@synthesize fiveHundredPlusPinImage=_fiveHundredPlusPinImage;

#pragma mark Handle Clustering:
//This method will handle running the clustering algorithm and adding the data points to the map.
-(void)handleClustering{
    
    //make sure that the cluster model is not nil
    if(!self.clusterModel){
        self.clusterModel = [[OOSMClusterModel alloc] initWithDataSet:self.stationPoints];
    }
    
    //Create a dicionary of points that are on the screen for the algorithm to cluster, and an array of the annotations that are on the screen so that only the zoomed in annotations (clusters or pins) are recalculated removed from the map.
    NSMutableDictionary *stationsShownOnMap = [[NSMutableDictionary alloc] init];
    for(OOSMMapPoint *currentStationPoint in [self.stationPoints allValues]){
    
        if(MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(currentStationPoint.position))){
            
            //get the point from the currentAnnotation and save it in the dicionary
            [stationsShownOnMap setObject:currentStationPoint forKey:currentStationPoint.serverID];
        }
    }
    
    self.clusterModel.densityRadius = self.mapView.region.span.latitudeDelta/12.0;
    self.clusterModel.dataSet = stationsShownOnMap;
    
    //Run the clustering algorithm.
    NSDictionary *dataPoints = [self.clusterModel dBSCAN];
    
   
    NSArray *annotationsOnMap = [self.mapView annotations];
    
    [self addClustersToMap:[dataPoints objectForKey:@"clusters"]];
    [self addStationsPointsToMap:[dataPoints objectForKey:@"noisePoints"]];
    
    [self.mapView removeAnnotations:annotationsOnMap];
    
    //Reset the visited values of the OOSMMapPoints.
    for(OOSMMapPoint *point in [self.stationPoints allValues]){
        point.visited = NO;
        point.isPartOfCluster = NO;
    }
}

-(void)addClustersToMap:(NSArray*)clusters{
    if(clusters){
        //For each cluster add an annotation to the map with the same coordinate.
        for(OOSMMapCluster *cluster in clusters){
            
            OOSMStationMapAnnotation *clusterAnotation = [[OOSMStationMapAnnotation alloc] initWithCoordinate:cluster.position];
            
            int numberOfStationsInCluster = (int)[cluster.pointsContained count];
            
            //Assign the numberOfStations property of the annotation to be used in giving the annotation images.
            if(numberOfStationsInCluster>50){clusterAnotation.numberOfStations = ClusterNumberFiftyPlus;}
            else if(numberOfStationsInCluster>100){clusterAnotation.numberOfStations = ClusterNumberOneHundredPlus;}
            else if(numberOfStationsInCluster>500){clusterAnotation.numberOfStations = ClusterNumberFiveHundredPlus;}
            
            clusterAnotation.isACluster = YES;
            [self.mapView addAnnotation:clusterAnotation];
        }
    }
}
-(void)addStationsPointsToMap:(NSDictionary*)stationPoints{
    for (int i = 0 ; i<[stationPoints allKeys].count; i++) {
        
        //get the station that corresponds to the stationPoint.
        OOSMStation *stationForAnnotation = [self.stations objectForKey:[[stationPoints allKeys] objectAtIndex:i]];
        
        [self addStationToMap:stationForAnnotation];
        
    }
}
-(void)addStationToMap:(OOSMStation*)station{
    
    //Set up an annotation on the map to represent the station.
    OOSMStationMapAnnotation *annotationForStation = [[OOSMStationMapAnnotation alloc] initWithCoordinate:station.location.coordinate];
    annotationForStation.station = station;
    [self.mapView addAnnotation:annotationForStation];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self handleClustering];
}

#pragma mark Handle Data:
-(void)dataEncounteredFatalError{
    //tell the delegate that an error occured.
    [self.mapDelegate mapViewControllerFailedToLoad];
}
-(void)dataHandlerFinished{
    
    [self handleClustering];
    
    //call when the data handler has finished parsing.
    [self.mapDelegate mapViewControllerFinishedLoading:self];
        
}

-(void)dataHandlerFoundStation:(OOSMStation *)station{
    
    //only add the station to the array if it's nameForServer property is not nil and does not equal @""
    if(station.nameForServer && ![station.nameForServer isEqualToString:@""] && station.serverid && ![station.serverid isEqualToString:@""]){
            
            //Add the station to the stations dictionary.
            [self.stations setObject:station forKey:station.serverid];
            //Add a point representing the station to the stationPoints.
            [self.stationPoints setObject:[station getPoint] forKey:station.serverid];
    }
}


#pragma mark Handle Map View Interaction:
//handle touches on the annotations
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if([view.annotation isKindOfClass:[OOSMStationMapAnnotation class]]){
        
        OOSMStationMapAnnotation *clusterAnnotation = ((OOSMStationMapAnnotation*)view.annotation);
        
        //if the touch was on a cluster, then expand the cluster
        if(clusterAnnotation.isACluster){
            [self.mapView setRegion:[self.mapView regionThatFits:MKCoordinateRegionMake(clusterAnnotation.coordinate, MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta/3.5, self.mapView.region.span.latitudeDelta/3.5))]];
        }else{
            self.tappedMapAnnotation=(OOSMStationMapAnnotation*)(view.annotation);
            [self performSegueWithIdentifier:@"StationInfo" sender:self];
        }
    }
}


#pragma mark Set Up Map View
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //reuse a new MKAnnotationView if one cannot be reused
    static NSString *viewIdentifier = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
    
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
    }
    
    //give the annotation a custom image based on the number of stations it represents.
    switch (((OOSMStationMapAnnotation*)annotation).numberOfStations) {
        case ClusterNumberFiftyPlus:
            annotationView.image = self.fiftyPlusPinImage;
            break;
        case ClusterNumberOneHundredPlus:
            annotationView.image = self.oneHundredPlusPinImage;
            break;
        case ClusterNumberFiveHundredPlus:
            annotationView.image = self.fiveHundredPlusPinImage;
            break;
        case ClusterNumberSingle:
            annotationView.image = self.defaultPinImage;
            break;
        default:
            break;
    }
    
    annotationView.frame = CGRectMake(0, 0, 30, 30);
    return annotationView;
}

-(void)createMap{
    self.defaultPinImage = [UIImage imageNamed:@"blue_buoy_icon_test.png"];
    self.fiftyPlusPinImage = [UIImage imageNamed:@"blue_buoy_icon_50_plus.png"];
    self.oneHundredPlusPinImage = [UIImage imageNamed:@"blue_buoy_icon_100_plus.png"];
    self.fiveHundredPlusPinImage = [UIImage imageNamed:@"blue_buoy_icon_500_plus.png"];
    
    //position the map
    self.mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate=self;
    
    MKCoordinateRegion regionToFocusOn=[self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(42, -70), 3500000, 3500000)];
    [self.mapView setRegion:regionToFocusOn];
    [self.view addSubview:self.mapView];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.destinationViewController respondsToSelector:@selector(setStationInfoToDisplay:)]){
        
        //provide the OOSMStationInfoViewController with the information it needs.
        OOSMStationInfoViewController *destinationViewController=segue.destinationViewController;
        [destinationViewController setStationInfoToDisplay:self.tappedMapAnnotation.station];
    }
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
    //initialize mutable dictionaries
    self.stations = [[NSMutableDictionary alloc] init];
    self.stationPoints = [[NSMutableDictionary alloc] init];
    
    //hide the back button
    [self.navigationItem setHidesBackButton:YES];

    //set up the map
    [self createMap];
    
    OOSMDataHandlerModel *dataHandlerModel=[[OOSMDataHandlerModel alloc] init];
    dataHandlerModel.delegate = self;
    
    self.coreLocationManager=[[CLLocationManager alloc] init];
    self.coreLocationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
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
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)shouldAutorotate{
    return NO;
}

@end
