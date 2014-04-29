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
@interface OOSMStationSensorView()
@property(strong, nonatomic)UILabel *propertyLabel;
@property(strong, nonatomic)UIImageView *propertyImage;

@end
@implementation OOSMStationSensorView
@synthesize sensorIconImageName = _sensorIconImageName;
@synthesize sensorPropertyValue = _sensorPropertyValue;
@synthesize propertyLabel = _propertyLabel;
@synthesize propertyImage = _propertyImage;


- (id)initWithFrame:(CGRect)frame sensorIconName:(NSString*)sensorIconName
sensorPropertyValue:(NSString*)sensorPropertyValue
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sensorPropertyValue = sensorPropertyValue;
        self.sensorIconImageName = [sensorIconName stringByAppendingString:@".png"];
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 0;
        
        self.propertyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.sensorIconImageName]];
        self.propertyImage.contentMode = UIViewContentModeScaleAspectFit;
        self.propertyImage.frame = CGRectMake(5, 0, (self.frame.size.width/2) - 10, self.frame.size.height);
        [self addSubview:self.propertyImage];
        
        self.propertyLabel = [[UILabel alloc] init];
        self.propertyLabel.text = self.sensorPropertyValue;
        [self.propertyLabel sizeToFit];
        self.propertyLabel.center = CGPointMake(self.frame.size.width*(3.0/4.0), self.center.y);
        [self addSubview:self.propertyLabel];
        
        
    }
    return self;
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
