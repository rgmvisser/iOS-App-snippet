//
//  RoomViewController.m
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomListViewController.h"
#import "RoomInfoViewController.h"
#import "RoomNotificationsViewController.h"
@interface RoomViewController ()
{
    RoomListViewController *_roomListVC;
    RoomInfoViewController *_roomInfoVC;
    RoomNotificationsViewController *_roomNotificationVC;
    int _currentSegment;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;

@end

@implementation RoomViewController

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
    
    [self setTitle:self.room.name];
    UIImage *segmentBackground = [UIImage imageNamed:@"bt_background"];
    
    [self.segmentControll setBackgroundImage:segmentBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControll setBackgroundImage:nil forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentControll setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    [self.segmentControll setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    CGRect viewContainerSize = self.viewContainer.frame;
    viewContainerSize.origin = CGPointZero;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    _roomListVC = (RoomListViewController *)[sb instantiateViewControllerWithIdentifier:@"roomListVC"];
    _roomListVC.room = self.room;
    _roomListVC.currentDate = self.currentDate;
    _roomListVC.view.frame = viewContainerSize;
    
    [self addChildViewController:_roomListVC];
    _currentSegment = 0;
    [self.viewContainer addSubview:_roomListVC.view];
    [_roomListVC didMoveToParentViewController:self];
    
    
    _roomInfoVC = (RoomInfoViewController *)[sb instantiateViewControllerWithIdentifier:@"roomInfoVC"];
    _roomInfoVC.room = self.room;
    _roomInfoVC.view.frame = viewContainerSize;
    [self addChildViewController:_roomInfoVC];
    
    _roomNotificationVC = (RoomNotificationsViewController *)[sb instantiateViewControllerWithIdentifier:@"roomNotificationVC"];
    _roomNotificationVC.room = self.room;
    _roomNotificationVC.view.frame = viewContainerSize;
    [self addChildViewController:_roomNotificationVC];
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)changeSegment:(id)sender {
    
    int selectedSegement = (int)self.segmentControll.selectedSegmentIndex;
    if(selectedSegement == _currentSegment)
    {
        return;
    }
    else{
        [self cycleFromViewController:[self vcForSegment:_currentSegment] toViewController:[self vcForSegment:selectedSegement]];
        _currentSegment = selectedSegement;

    }
}

- (UIViewController *)vcForSegment:(int)segment
{
    if(segment == 0)
    {
        return _roomListVC;
    }else if (segment == 1){
        return _roomInfoVC;
    }else if (segment == 2){
        return _roomNotificationVC;
    }
    return [[UIViewController alloc] init];
}

- (void) cycleFromViewController: (UIViewController*) oldVC
                toViewController: (UIViewController*) newVC
{
    
    [oldVC.view removeFromSuperview];
    [self.viewContainer addSubview:newVC.view];
    [oldVC willMoveToParentViewController:nil];
    [newVC didMoveToParentViewController:self];
    
    
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
