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
    
    CGFloat elementBorder = 10;
    CGFloat startingXForNextElement = CGRectGetMaxX(self.stationNameLabel.frame) + elementBorder;
    
    //Create a UIScrollView to hold all of the images and labels.
    UIScrollView *propertyScrollView = [[UIScrollView alloc] init];
    propertyScrollView.frame = CGRectMake(0, 0, self.bounds.size.width - elementBorder - CGRectGetMaxX(self.stationNameLabel.bounds), self.bounds.size.height-(2 * elementBorder));
    propertyScrollView.center = CGPointMake(self.bounds.size.width - (elementBorder * 2) - CGRectGetMaxX(self.stationNameLabel.bounds), self.bounds.size.height - (elementBorder * 2));
    
    //Lay out images and values for each key/value pair in the dictionary.
    for(int i = 0; i < [propertyValues allKeys].count; i++){
        NSString *property = [[propertyValues allKeys] objectAtIndex:i];
        
        UIImageView *propertyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[property stringByAppendingString:@".png"]]];
        propertyImage.frame = CGRectMake(0, 0, 50, 100);
        propertyImage.center = CGPointMake(startingXForNextElement + propertyImage.bounds.size.width/2, self.bounds.size.height/2);
        [propertyScrollView addSubview:propertyImage];
        
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = [[propertyValues allValues] objectAtIndex:i];
        [valueLabel sizeToFit];
        valueLabel.center = CGPointMake(CGRectGetMaxX(propertyImage.bounds) + elementBorder, self.bounds.size.height/2);
        [propertyScrollView addSubview:valueLabel];
        
        startingXForNextElement = CGRectGetMaxX(valueLabel.bounds) + elementBorder;
    }
    
    propertyScrollView.contentSize = CGSizeMake(startingXForNextElement - (CGRectGetMaxX(self.stationNameLabel.frame) + elementBorder), propertyScrollView.frame.size.height);
    
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
