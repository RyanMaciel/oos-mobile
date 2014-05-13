//
//  OOSMCustomButton.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 5/12/14.
//
//  Copyright (c) 2013 RPS ASA. All rights reserved.
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

#import "OOSMCustomButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation OOSMCustomButton

//This class is a simple simple subclass of UIButton which will add a border and rounded corners to the default button.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 10.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}


@end
