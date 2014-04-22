//
//  OOSMNavigationViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 3/11/14.
//  Copyright (c) 2014 RPS ASA. All rights reserved.
//

#import "OOSMNavigationViewController.h"
#import "OOSMWebViewController.h"

@interface OOSMNavigationViewController ()

@end

@implementation OOSMNavigationViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    if([self.visibleViewController isKindOfClass:[OOSMWebViewController class]]){
        
        //only allow the interface orientation to be landscape in the web view.
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if([self.visibleViewController isKindOfClass:[OOSMWebViewController class]]){
        
        //only allow the interface orientation to be landscape in the web view.
        return UIInterfaceOrientationLandscapeLeft;
    }
    
    return UIInterfaceOrientationPortrait;
}
@end