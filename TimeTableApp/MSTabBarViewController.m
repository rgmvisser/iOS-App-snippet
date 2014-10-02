//
//  MSTabBarViewController.m
//  TimetableApp
//
//  Created by Ruud Visser on 27-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MSTabBarViewController.h"
#import "AppSettings.h"
#import "MSNetworking.h"
@interface MSTabBarViewController ()

@end

@implementation MSTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"Isstil: %d",[[AppSettings sharedInstance] isStillLoggedIn]);
    //Check if user is still logged in
    if(![[AppSettings sharedInstance] isStillLoggedIn]){ // you do not want to get the user info twice in one session
        
        [[MSNetworking sharedMSClient] loginWithSuccess:^(BOOL loggedIn) {
            
            if(loggedIn){
                
                //still logged in, nice
                
            }else{
                if([[[MSNetworking sharedMSClient] reachabilityManager] isReachable]){
                    [self logout];
                    [[[UIAlertView alloc] initWithTitle:@"Fout" message:@"Er is iets mis gegaan bij het inloggen" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Let op" message:@"Geen internet beschikbaar, check uw connectie" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
                
                
            }
            
        }];
        
    }
    // Do any additional setup after loading the view.
}

- (void)logout
{
    [[AppSettings sharedInstance] logoutUser];
    UINavigationController *nav =  (UINavigationController *)self.navigationController;
    [nav popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
