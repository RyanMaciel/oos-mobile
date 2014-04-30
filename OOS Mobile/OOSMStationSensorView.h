//
//  OOSMStationSensorView.h
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

#import <UIKit/UIKit.h>

@interface OOSMStationSensorView : UIView
@property(strong, nonatomic)NSString *sensorIconImageName;
@property(strong, nonatomic)NSString *sensorPropertyValue;
-(id)initWithFrame:(CGRect)frame
    sensorIconName:(NSString*)sensorIconName
sensorPropertyValue:(NSString*)sensorPropertyValue;
@end