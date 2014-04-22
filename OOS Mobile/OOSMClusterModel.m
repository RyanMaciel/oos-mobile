//
//  OOSMClusterModel.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 3/25/14.
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

#import "OOSMClusterModel.h"
#import "OOSMMapCluster.h"
#import "OOSMMapPoint.h"

@interface OOSMClusterModel()
@property(nonatomic)int minPoints;
@property(strong, nonatomic)NSMutableArray *clusters;
@property(strong, nonatomic)NSMutableDictionary *noisePoints;


-(void)expandCluster:(OOSMMapCluster*)cluster neigborPoints:(NSArray*)neighbors startPoint:(OOSMMapPoint*)startPoint;
-(NSArray*)regionQueryForPoint:(OOSMMapPoint*)point;
-(float)getDistanceBetweenPoint1:(OOSMMapPoint*)point1 andPoint2:(OOSMMapPoint*)point2;
@end
@implementation OOSMClusterModel
@synthesize dataSet=_dataSet;
@synthesize densityRadius=_densityRadius;
@synthesize minPoints=_minPoints;
@synthesize clusters=_clusters;
@synthesize noisePoints=_noisePoints;

-(NSDictionary*)dBSCAN{
    //This method can be called multiple times, so self.clusters must be cleared every time
    [self.clusters removeAllObjects];
    [self.noisePoints removeAllObjects];
    
    for(OOSMMapPoint *currentPoint in [self.dataSet allValues]){
        if(!currentPoint.visited){
            
            //set p as visited
            currentPoint.visited = YES;
            
            NSArray *neighborPoints = [self regionQueryForPoint:currentPoint];
            
            if(neighborPoints.count < self.minPoints){
                [self.noisePoints setObject:currentPoint forKey:currentPoint.serverID];
            
            }else{
                //create a new cluster and add it to the array
                OOSMMapCluster *newCluster = [[OOSMMapCluster alloc] init];
                [self.clusters addObject:newCluster];
                
                [self expandCluster:newCluster neigborPoints:neighborPoints startPoint:currentPoint];
                
                
                //set the cluster's position to be the average center of all its positions
                float totalXValues = 0.0;
                float totalYValues = 0.0;
                for(OOSMMapPoint *point in newCluster.pointsContained){
                    totalXValues += point.position.latitude;
                    totalYValues += point.position.longitude;
                }
                newCluster.position = CLLocationCoordinate2DMake(totalXValues/(float)newCluster.pointsContained.count, totalYValues/(float)newCluster.pointsContained.count);
                
            }
        }
    }
    //create a dictionary to return.  This dictionary will have two key-value pairs.  The first will be "clusters" with the value set to the self.clusters dictionary.
    //The second will be "NoisePoints" with the valuew set to the self.noisePointDictionary
    return @{@"clusters": self.clusters, @"noisePoints": self.noisePoints};
    
}

-(void)expandCluster:(OOSMMapCluster*)cluster neigborPoints:(NSMutableArray *)neighbors startPoint:(OOSMMapPoint *)startPoint{
    [cluster.pointsContained addObject:startPoint];
    
    //In this case doing a normal for loop is faster than fast enumeration because the neighbors dictionary has to be mutated as it is enumerated/
    long limit = neighbors.count;
    for(int i = 0; i<limit; i++){
        
        OOSMMapPoint *neighborPoint = [neighbors objectAtIndex:i];
        
        if(!neighborPoint.visited){
            neighborPoint.visited = YES;
            
            NSArray *neighborPointsOfNeighbor = [self regionQueryForPoint:neighborPoint];
            if(neighborPointsOfNeighbor.count >= self.minPoints){
                
                limit+=neighborPointsOfNeighbor.count;
                [neighbors addObjectsFromArray:neighborPointsOfNeighbor];
            }
            
            //if the neighbor point is not inside of a cluster, then add it to the current one.
            if(!neighborPoint.isPartOfCluster){
                [cluster.pointsContained addObject:neighborPoint];
            }
        }
    }
    
}

-(NSArray*)regionQueryForPoint:(OOSMMapPoint *)point{
    //return the points within the distance of self.desityRadius
    
    NSMutableArray *pointsInRegion = [[NSMutableArray alloc] init];
    
    for(OOSMMapPoint* queryPoint in [self.dataSet allValues]){
        if([self getDistanceBetweenPoint1:point andPoint2:queryPoint] <= self.densityRadius){
            [pointsInRegion addObject:queryPoint];
        }
    }
    return pointsInRegion;
}

-(float)getDistanceBetweenPoint1:(OOSMMapPoint *)point1 andPoint2:(OOSMMapPoint *)point2{
    
    CGFloat dx = point2.position.latitude - point1.position.latitude;
    CGFloat dy = point2.position.longitude - point1.position.longitude;
    
    return sqrt(dx*dx + dy*dy );
}

-(id)initWithDataSet:(NSDictionary *)dataSet{
    self = [super init];
    if(self){
        
        //set up everything needed to create the clusters.
        self.dataSet = dataSet;
        self.densityRadius = 5;
        self.minPoints = 40;
        self.clusters = [[NSMutableArray alloc] init];
        self.noisePoints = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
 DBSCAN(D, eps, MinPts)
 C = 0
 for each unvisited point P in dataset D
 mark P as visited
 NeighborPts = regionQuery(P, eps)
 if sizeof(NeighborPts) < MinPts
 mark P as NOISE
 else
 C = next cluster
 expandCluster(P, NeighborPts, C, eps, MinPts)
 
 expandCluster(P, NeighborPts, C, eps, MinPts)
 add P to cluster C
 for each point P' in NeighborPts
 if P' is not visited
 mark P' as visited
 NeighborPts' = regionQuery(P', eps)
 if sizeof(NeighborPts') >= MinPts
 NeighborPts = NeighborPts joined with NeighborPts'
 if P' is not yet member of any cluster
 add P' to cluster C
 
 regionQuery(P, eps)
 return all points within P's eps-neighborhood (including P)
 */
@end