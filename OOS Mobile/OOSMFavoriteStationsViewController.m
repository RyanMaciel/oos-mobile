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

@interface OOSMFavoriteStationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic)IBOutlet UITableView *mainTableView;
@property(strong, nonatomic)NSArray *userFavs;
@property(strong, nonatomic)NSUserDefaults *userDefaults;
@property(strong, nonatomic)OOSMStation *stationTappedOn;
@end

@implementation OOSMFavoriteStationsViewController
@synthesize mainTableView=_mainTableView;
@synthesize userFavs=_userFavs;
@synthesize stationTappedOn=_stationTappedOn;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[OOSMStationInfoViewController class]]){
        [((OOSMStationInfoViewController*)segue.destinationViewController) setStationInfoToDisplay:self.stationTappedOn];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableViewTitle = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
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
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userFavs.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //give the table view a cell to display
    static NSString *cellIdentifier = @"Stations Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //get the text to display
    if(indexPath.row < self.userFavs.count){
        NSString *cellString = [[self.userFavs objectAtIndex:indexPath.row] objectForKey:@"User Readable Name"];
        
        if(cellString){
            
        cell.textLabel.text = cellString;
        }
    }
    return cell;
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
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.userFavs=[self.userDefaults arrayForKey:@"kUserFavoriteStations"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
