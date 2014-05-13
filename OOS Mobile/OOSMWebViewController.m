//
//  OOSMWebViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 2/10/14.
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
#import "OOSMWebViewController.h"

@interface OOSMWebViewController () <UIWebViewDelegate>
@property(strong, nonatomic)IBOutlet UIWebView *mainWebView;
@property(strong, nonatomic)IBOutlet UIActivityIndicatorView *loadingView;
@property(strong, nonatomic)IBOutlet UILabel *errorMessageLabel;

@property(strong, nonatomic)NSDictionary *propertyXAndYValues;
-(void)getTSVData;
-(NSString*)xPropertyValueForPropertyNamed:(NSString*)property;
-(NSString*)yPropertyValueForPropertyNamed:(NSString*)property;

@end

@implementation OOSMWebViewController
@synthesize mainWebView=_mainWebView;
@synthesize webViewURL=_webViewURL;
@synthesize loadingView=_loadingView;
@synthesize propertyXAndYValues=_propertyXAndYValues;
@synthesize propertyToGraph=_propertyToGraph;
@synthesize errorMessageLabel=_errorMessageLabel;

-(NSString*)xPropertyValueForPropertyNamed:(NSString*)property{
    return [self.propertyXAndYValues objectForKey:[property stringByAppendingString:@"X"]];
}
-(NSString*)yPropertyValueForPropertyNamed:(NSString*)property{
    return [self.propertyXAndYValues objectForKey:[property stringByAppendingString:@"Y"]];
}

#pragma mark handle TSV request:
-(void)getTSVData{
    NSLog(@"%@",self.webViewURL);
    //create a NSURLRequest
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.webViewURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        
        if(!error){
            
            NSLog(@"Request worked");
            
            //create a string from the data
            NSString *tsvString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
            
            //run this on the main thread
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void){
                
                //stop the loading view:
                [self.loadingView stopAnimating];
                
                //give the CSV to the javascript
                [self.mainWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"parseCSV(\"%@\", \"%@\", \"%@\");", [[[tsvString stringByReplacingOccurrencesOfString:@"\"" withString:@"'"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"\\n"], [self xPropertyValueForPropertyNamed:self.propertyToGraph], [self yPropertyValueForPropertyNamed:self.propertyToGraph]]];
                
            }];

        }else{
            NSLog(@"%@",[error description]);
            self.errorMessageLabel.hidden = NO;
            [self.loadingView stopAnimating];
            
        }
        
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self getTSVData];
}
- (void)viewDidLoad
{

    self.errorMessageLabel.hidden = YES;
    //change the interface orientation
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //set up a NSDictionary to store all of the x and y values the JavaScript should look up to create the graph.
    self.propertyXAndYValues = @{@"relative_humidityX":@"date_time", @"relative_humidityY":@"\'relative_humidity (percentage)\'",@"air_temperatureX":@"date_time", @"air_temperatureY":@"\'air_temperature (C)\'", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tideX":@"date_time", @"sea_surface_height_amplitude_due_to_equilibrium_ocean_tideY":@"\'sea_surface_height_amplitude_due_to_equilibrium_ocean_tide (m)\'", @"windsX":@"date_time", @"windsY":@"\'wind_speed (m/s)\'", @"air_pressureX":@"date_time", @"air_pressureY":@"\'air_pressure (mb)\'", @"sea_water_temperatureX":@"date_time", @"sea_water_temperatureY": @"\'sea_water_temperature (C)\'", @"rain_fallX":@"date_time", @"rain_fallY": @"\'rain_fall (millimeters\'", @"visibilityX" : @"date_time", @"visibilityY" : @"\'visibility (nautical miles)\'", @"currentsX" : @"date_time", @"currentsY" : @"\'sea_water_speed (cm/s)\'", @"sea_water_salinityX" : @"date_time", @"sea_water_salinityY" : @"\'sea_water_salinity (psu)\'"};
    
    self.mainWebView.delegate = self;
    
    NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"D3Main" ofType:@"html" inDirectory:@"www"]];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:htmlFile]];
    //[self.mainWebView stringByEvaluatingJavaScriptFromString:@"parseWithTSVData()"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end
