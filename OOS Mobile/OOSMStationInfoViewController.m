//
//  OOSMStationInfoViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 12/17/13.
//  Copyright (c) 2013 RPS ASA. All rights reserved.
//
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

#import "OOSMStationInfoViewController.h"

@interface OOSMStationInfoViewController ()
@property(strong, nonatomic)IBOutlet UILabel *titleLable;
@property(strong, nonatomic)OOSMStation *stationToDisplayInfo;
@end

@implementation OOSMStationInfoViewController
@synthesize titleLable=_titleLable;
@synthesize stationToDisplayInfo=_stationToDisplayInfo;

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
    self.titleLable.text=[self.stationToDisplayInfo getName];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
