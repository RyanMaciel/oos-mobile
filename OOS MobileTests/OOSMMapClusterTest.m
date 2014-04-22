//
//  OOSMMapClusterTest.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 3/25/14.
//  Copyright (c) 2014 RPS ASA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OOSMClusterModel.h"
#import "OOSMMapCluster.h"
#import "OOSMMapPoint.h"
@interface OOSMMapClusterTest : XCTestCase

@end

@implementation OOSMMapClusterTest

-(void)testClusterAlgorithm{
    OOSMMapPoint *position1 = [[OOSMMapPoint alloc] init];
    position1.position = CLLocationCoordinate2DMake(10, 15);
    OOSMMapPoint *position2 = [[OOSMMapPoint alloc] init];
    position2.position = CLLocationCoordinate2DMake(-10, 15);
    OOSMMapPoint *position3 = [[OOSMMapPoint alloc] init];
    position3.position = CLLocationCoordinate2DMake(10, -15);
    OOSMMapPoint *position4 = [[OOSMMapPoint alloc] init];
    position4.position = CLLocationCoordinate2DMake(-10, -15);
    
    NSDictionary *dataSet = @{@"key" : position1, @"key2" : position2, @"key3" : position3, @"key4" : position4};
    OOSMClusterModel *clusterModel = [[OOSMClusterModel alloc] initWithDataSet:dataSet];
    NSArray *clusters = [clusterModel dBSCAN];
    
    //test that the cluster array is not nil
    XCTAssert(clusters, @"The algorithm returned an empty array");
    
    //test the number of clusters returned
    XCTAssert(clusters.count == 2, @"The clustering algorthim returned a unexpected amount of clusters");
    
    //test that the clusters are positioned correctly.
    CLLocationCoordinate2D cluster1Coord = ((OOSMMapCluster*)[clusters objectAtIndex:0]).position;
    XCTAssert(((cluster1Coord.latitude == 0 && cluster1Coord.longitude == 15) || (cluster1Coord.latitude == 0 && cluster1Coord.longitude == 0-15)), @"The first cluster was not positioned correctly.");
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
