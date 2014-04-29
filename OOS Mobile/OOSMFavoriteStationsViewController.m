//
//  OOSMFavoriteStationsViewController.m
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
#import "OOSMFavoriteStationsViewController.h"
#import "OOSMStation.h"
#import "OOSMStationInfoViewController.h"
#import "OOSMFavStationTableViewCell.h"
#import "OOSMParseHelperOperation.h"

@interface OOSMFavoriteStationsViewController () <UITableViewDataSource, UITableViewDelegate, OOSMParseOperationDelegate>

@property(strong, nonatomic)IBOutlet UITableView *mainTableView;
@property(strong, nonatomic)NSMutableArray *userFavs;
@property(strong, nonatomic)NSUserDefaults *userDefaults;
@property(strong, nonatomic)OOSMStation *stationTappedOn;
@property(strong, nonatomic)NSIndexPath *selectedPath;
@property(strong, nonatomic)NSMutableArray *tableViewCellNames;
@end

@implementation OOSMFavoriteStationsViewController
@synthesize mainTableView=_mainTableView;
@synthesize userFavs=_userFavs;
@synthesize stationTappedOn=_stationTappedOn;
@synthesize selectedPath=_selectedPath;
@synthesize tableViewCellNames=_tableViewCellNames;

//Delegate method for getting the temperature and wind speed at a station.
-(void)parseHelperReturnedDictionary:(NSDictionary *)stationProperties forStationNamed:(NSString*)station{

    for(int i=0; i<self.tableViewCellNames.count; i++){

        if([station isEqualToString:[self.tableViewCellNames objectAtIndex:i]]){
            
            OOSMFavStationTableViewCell *favoriteCell = (OOSMFavStationTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [favoriteCell setUpWithDictionaryOfPropertiesAndValues:stationProperties];
        }
    }
    
    for(NSString *key in [stationProperties allKeys]){
        NSLog(@"%@ <--%@",[stationProperties objectForKey:key], key);
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[OOSMStationInfoViewController class]]){
        [((OOSMStationInfoViewController*)segue.destinationViewController) setStationInfoToDisplay:self.stationTappedOn];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //set the selected path
    self.selectedPath = indexPath;
    
    NSString *tableViewTitle = ((OOSMFavStationTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).stationName;
    NSString *nameForServer;
    //get the name for sever for the station that has been tapped on.
    for(int i=0; i<self.userFavs.count; i++){
        if([[[self.userFavs objectAtIndex:i] objectForKey:@"User Readable Name"] isEqualToString:tableViewTitle]){
            nameForServer = [[self.userFavs objectAtIndex:i] objectForKey:@"Server Name"];
        }
        
    }
    
    //make a new OOSMStation to represent the station that has been tapped on.
    OOSMStation *newStation = [[OOSMStation alloc] initWithUserReadableName:tableViewTitle nameForServer:nameForServer location:nil];
    self.stationTappedOn = newStation;
    
    [self performSegueWithIdentifier:@"StationInfo" sender:self];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (int)self.userFavs.count;
}

//respond to editing of the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
    
        //Remove from the user favs array.
        [self.userFavs removeObjectAtIndex:[indexPath row]];
        
        //Update the user defaults.
        [self.userDefaults setObject:self.userFavs forKey:@"kUserFavoriteStations"];
        
        //remove cell from table view.
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //give the table view a cell to display
    static NSString *cellIdentifier = @"Stations Identifier";
    NSLog(@"%@", cellIdentifier);
    OOSMFavStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        @try {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OOSMFavStationCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    //get the text to display
    if(indexPath.row < self.userFavs.count){
        NSString *cellString = [[self.userFavs objectAtIndex:indexPath.row] objectForKey:@"User Readable Name"];
        if(cellString){
            
        cell.stationName = cellString;
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    //deselect the selected row.
    [self.mainTableView deselectRowAtIndexPath:self.selectedPath animated:NO];
    [super viewWillAppear:animated];

}
- (void)viewDidLoad
{
    //Get the user's favorite stations.
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.userFavs=[[self.userDefaults arrayForKey:@"kUserFavoriteStations"] mutableCopy];
    
    //Set up a NSMutableArray to hold the names of all the stations.
    self.tableViewCellNames = [[NSMutableArray alloc] init];
    for(NSDictionary *stationRepresentation in self.userFavs){
        [self.tableViewCellNames addObject:[stationRepresentation objectForKey:@"Server Name"]];
    }
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.name = @"getInfoForUserFavorites";
    
    for(int i  = 0; i<self.userFavs.count; i++){
        OOSMParseHelperOperation *newOperation = [[OOSMParseHelperOperation alloc] initWithDelegate:self stationName:[[self.userFavs objectAtIndex:i] objectForKey:@"Server Name"] elementsToFind:@{@"air_temperature": @"", @"winds": @""}];
        
        newOperation.queuePriority = NSOperationQueuePriorityHigh;
        [operationQueue addOperation:newOperation];
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
