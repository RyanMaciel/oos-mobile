//
//  OOSMStationSensorView.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 4/29/14.
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

#import "OOSMStationSensorView.h"
#import <QuartzCore/QuartzCore.h>
#import "OOSMStationInfoViewController.h"

@interface OOSMStationSensorView()
@property(strong, nonatomic)UILabel *propertyLabel;
@property(strong, nonatomic)UIImageView *propertyImage;
@property(strong, nonatomic)NSString *sensorIconImageName;
@property(strong, nonatomic)NSString *sensorPropertyValue;

@end
@implementation OOSMStationSensorView
@synthesize sensorIconImageName = _sensorIconImageName;
@synthesize sensorPropertyValue = _sensorPropertyValue;
@synthesize propertyLabel = _propertyLabel;
@synthesize propertyImage = _propertyImage;
@synthesize stationInfoViewController = _stationInfoViewController;
@synthesize propertyObserved = _propertyObserved;

- (id)initWithFrame:(CGRect)frame sensorIconName:(NSString*)sensorIconName
sensorPropertyValue:(NSString*)sensorPropertyValue
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sensorPropertyValue = sensorPropertyValue;
        self.propertyObserved = sensorIconName;
        self.sensorIconImageName = [sensorIconName stringByAppendingString:@".png"];
        
        NSDictionary *unitsForSensor = @{@"air_temperature": @"ºC", @"air_pressure": @"mb", @"relative_humidity": @"%", @"rain_fall": @"centimeters", @"visibility": @"km", @"sea_water_electrical_conductivity": @"S/m", @"currents": @"", @"sea_water_salinity": @"", @"water_surface_height_above_reference_datum": @"", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tide": @"", @"sea_water_temperature": @"ºC", @"winds":@"m/s", @"harmonic_constituents":@"", @"datums":@"", @"rain_fall":@"mm", @"visibility":@"NM", @"currents" : @"cm/s", @"sea_water_salinity" : @"psu"};
        
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.propertyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.sensorIconImageName]];
        self.propertyImage.contentMode = UIViewContentModeScaleAspectFit;
        self.propertyImage.frame = CGRectMake(5, 0, (self.frame.size.width/2) - 10, self.frame.size.height);
        [self addSubview:self.propertyImage];
        
        self.propertyLabel = [[UILabel alloc] init];
        self.propertyLabel.text = [[self.sensorPropertyValue stringByAppendingString:@" "] stringByAppendingString:[unitsForSensor objectForKey:sensorIconName]];
        self.propertyLabel.numberOfLines = 2;
        self.propertyLabel.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        self.propertyLabel.center = CGPointMake(self.frame.size.width*(3.0/4.0), self.center.y);
        [self addSubview:self.propertyLabel];
        
        
    }
    return self;
}

//Change the background color of the view to make it appear to be a button when clicked.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor whiteColor];
    
    if([self.stationInfoViewController isKindOfClass:[OOSMStationInfoViewController class]]){
        [((OOSMStationInfoViewController*)self.stationInfoViewController) stationSensorViewWasTouched:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
