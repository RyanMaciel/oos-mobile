//
//  OOSMFavStationTableViewCell.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 4/8/14.
//  Copyright (c) 2014 RPS ASA. All rights reserved.
//
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

#import "OOSMFavStationTableViewCell.h"
@interface OOSMFavStationTableViewCell()
@property(strong, nonatomic)IBOutlet UILabel *stationNameLabel;
@property(strong, nonatomic)IBOutlet UILabel *airTemperatureLabel;
@property(strong, nonatomic)IBOutlet UILabel *windSpeedLabel;
@property(strong, nonatomic)IBOutlet UIImageView *windImage;
@property(strong, nonatomic)IBOutlet UIImageView *temperatureImage;
@end

@implementation OOSMFavStationTableViewCell
@synthesize stationName=_stationName;
@synthesize stationNameLabel=_stationNameLabel;
@synthesize airTemperatureLabel=_airTemperatureLabel;
@synthesize windSpeedLabel=_windSpeedLabel;
@synthesize windImage=_windImage;
@synthesize temperatureImage=_temperatureImage;

-(void)setUpWithDictionaryOfPropertiesAndValues:(NSDictionary *)propertyValues{

    NSDictionary *unitsForSensor = @{@"air_temperature": @"ºC", @"air_pressure": @"mb", @"relative_humidity": @"%", @"rain_fall": @"centimeters", @"visibility": @"km", @"sea_water_electrical_conductivity": @"S/m", @"currents": @"", @"sea_water_salinity": @"", @"water_surface_height_above_reference_datum": @"", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tide": @"", @"sea_water_temperature": @"ºC", @"winds":@"m/s", @"harmonic_constituents":@"", @"datums":@""};
    
    CGFloat elementBorder = 10;
    CGFloat startingXForNextElement = elementBorder;
    
    //Create a UIScrollView to hold all of the images and labels.
    UIScrollView *propertyScrollView = [[UIScrollView alloc] init];
    propertyScrollView.frame = CGRectMake(0, 0, self.bounds.size.width - elementBorder - CGRectGetMaxX(self.stationNameLabel.bounds), self.bounds.size.height-(2 * elementBorder));
    propertyScrollView.center = CGPointMake(self.bounds.size.width - (elementBorder * 2) - CGRectGetMaxX(self.stationNameLabel.bounds), (self.bounds.size.height/2) - elementBorder);
    
    //Lay out images and values for each key/value pair in the dictionary.
    for(int i = 0; i < [propertyValues allKeys].count; i++){

        NSString *property = [[propertyValues allKeys] objectAtIndex:i];
        
        UIImageView *propertyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[property stringByAppendingString:@".png"]]];
        propertyImage.frame = CGRectMake(0, 0, 50, 100);
        propertyImage.contentMode = UIViewContentModeScaleAspectFit;
        propertyImage.center = CGPointMake(startingXForNextElement + propertyImage.frame.size.width/2, self.frame.size.height/2);
        [propertyScrollView addSubview:propertyImage];
        
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = [[propertyValues allValues] objectAtIndex:i];
        
        //add a unit label besides the value.
        if([unitsForSensor objectForKey:[[propertyValues allValues] objectAtIndex:i]]){
            [valueLabel.text stringByAppendingString:[[valueLabel.text stringByAppendingString:@" "] stringByAppendingString:[unitsForSensor objectForKey:[[propertyValues allValues] objectAtIndex:i]]] ];
        }
        [valueLabel sizeToFit];
        valueLabel.center = CGPointMake(valueLabel.frame.size.width/2 + propertyImage.center.x + propertyImage.frame.size.width/2 + elementBorder, self.bounds.size.height/2);
        [propertyScrollView addSubview:valueLabel];
        
        startingXForNextElement = valueLabel.center.x + valueLabel.frame.size.width/2 + elementBorder;
    }
    
    propertyScrollView.contentSize = CGSizeMake(startingXForNextElement + elementBorder, propertyScrollView.frame.size.height);
    
    [self addSubview:propertyScrollView];
}

-(void)setStationName:(NSString *)stationName{
    self.stationNameLabel.text = stationName;
    _stationName = stationName;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
