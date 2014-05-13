//
//  OOSMLoadingViewController.m
//  OOS Mobile
//
//  Created by Ryan Maciel on 3/11/14.
//  Copyright (c) 2014 RPS ASA. All rights reserved.
//

#import "OOSMLoadingViewController.h"
#import "OOSMMapViewController.h"
#import "Reachability.h"

@interface OOSMLoadingViewController () <OOSMMapLoadingDelegate>
@property(strong, nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@property(strong, nonatomic)IBOutlet UILabel *errorLabel;
@end

@implementation OOSMLoadingViewController
@synthesize indicator=_indicator;
@synthesize errorLabel=_errorLabel;

//this is called when an error has occured.
-(void)mapViewControllerFailedToLoad{
    //show the error label.
    self.errorLabel.hidden = NO;
}

-(void)mapViewControllerFinishedLoading:(OOSMMapViewController *)mapController{
    [self.indicator stopAnimating];
    
    //push to the map view controller
    if(self.navigationController){
        [self.navigationController pushViewController:mapController animated:YES];
    }
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //hide the error label
    self.errorLabel.hidden = YES;
    
    //check for network reachability:
    Reachability *reachabilityChecker = [Reachability reachabilityWithHostName:@"opendap.co-ops.nos.noaa.gov"];
    reachabilityChecker.reachableBlock = ^(Reachability*reach)
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^(void){
        
            NSLog(@"The host is reachable");
            
            //initiate the map view controller
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
            
            OOSMMapViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            viewController.mapDelegate = self;
            
            //force -viewDidLoad to be called
            [viewController view];
        }];

    };
    reachabilityChecker.unreachableBlock = ^(Reachability*reach)
    {
        //call the error delegate method on self if the host is not reachable.
        NSLog(@"Host not reachable");
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void){
            [self mapViewControllerFailedToLoad];

        }];
        
    };

    [reachabilityChecker startNotifier];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
