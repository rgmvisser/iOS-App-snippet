//
//  RoomsTableViewController.m
//  Timetableapp
//
//  Created by Ruud Visser on 13-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "RoomsTableViewController.h"
#import "VLLokaalTableViewCell.h"
#import "Room.h"
#import "RoomInfoViewController.h"
@interface RoomsTableViewController ()

@end

@implementation RoomsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)cancelRoom:(id)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"Let op" message:@"Dit is in deze versie nog niet beschikbaar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.booking.rooms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLLokaalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VLLokaalTableViewCell" forIndexPath:indexPath];
    Room *room = [self.booking.rooms objectAtIndex:indexPath.row];
    [cell.buildingLabel setText:room.name];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room *room = [self.booking.rooms objectAtIndex:indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setTitle:room.name];
    
    CGRect frame = vc.view.frame;
    frame.origin.y = 64;
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    [vc.view addSubview:containerView];
    
    RoomInfoViewController *rivc = (RoomInfoViewController *)[sb instantiateViewControllerWithIdentifier:@"roomInfoVC"];
    rivc.room = room;
    
    [vc addChildViewController:rivc];
    [containerView addSubview:rivc.view];
    [rivc didMoveToParentViewController:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
