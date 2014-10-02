//
//  VrijeLokalenViewController.m
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "VrijeLokalenViewController.h"

//Custom Table Cell Views
#import "VLDateTableViewCell.h"
#import "VLLokaalTableViewCell.h"
#import "MSLabel.h"
#import "TimeGridUnit.h"
#import "Room.h"
#import "MSNetworking.h"
#import "NSDateFormatter+Locale.h"
#import "BoekenBevestigenViewController.h"
#import "RoomViewController.h"

@interface VrijeLokalenViewController ()
{
    NSArray *_timeGridUnits;
    BOOL _isSearching;
}
@property (weak, nonatomic) IBOutlet MSLabel *dateLabel;
@end

@implementation VrijeLokalenViewController

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
    _isSearching = YES;
    _timeGridUnits = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] initWithLocale];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    [self.dateLabel setText:[[dateFormatter stringFromDate:self.selectedDate] capitalizedString]];
    
    // Do any additional setup after loading the view
    DLog(@"Info: %@, %@, %@",self.showOnlyFreeRooms,self.selectedDate,self.selectedObjects);
    
    [[MSNetworking sharedMSClient] getRooms:self.showOnlyFreeRooms onDate:self.selectedDate withObjects:self.selectedObjects withSuccess:^(NSArray *timeGridUnits) {
        
        //@TODO sleep weghalen
        //sleep(1);
        
        _timeGridUnits = timeGridUnits;
        _isSearching = NO;
        [self.tableView reloadData];
    }];
    
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(_isSearching)
    {
        return 1;
    }
    return [_timeGridUnits count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(_isSearching){
        return 0;
    }
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(_isSearching){
        return nil;
    }
    VLDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VLDateTableViewCell"];
    
    TimeGridUnit *tgu = [_timeGridUnits objectAtIndex:section];
    NSString *startString = [NSDateFormatter timeStringFromDate:tgu.timeStart];
    NSString *endString = [NSDateFormatter timeStringFromDate:tgu.timeEnd];
    DLog(@"Starttime: %@",tgu.timeStart);
    NSString *header = [NSString stringWithFormat:@"%@ | %@ - %@ uur",tgu.name,startString,endString];
    [cell.timeLabel setText:header];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearching)
    {
        return 1;
    }
    TimeGridUnit *tgu = [_timeGridUnits objectAtIndex:section];
    return [tgu.rooms count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 54;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isSearching){
        DLog(@"Searching cell!");
        return [tableView dequeueReusableCellWithIdentifier:@"searchTableViewCell" forIndexPath:indexPath];
        
    }
    NSString *identifier = @"VLLokaalTableViewCell";
    VLLokaalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    TimeGridUnit *item = [_timeGridUnits objectAtIndex:[indexPath section]];
    Room *room = [item.rooms objectAtIndex:indexPath.row];
    [cell.buildingLabel setText: room.name];
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
   
    if([segue.identifier isEqualToString:@"showRoomInfo"] || [segue.identifier isEqualToString:@"showRoomInfo2"])
    {
        //get clicked cell
        UITableViewCell *cell;
        if([segue.identifier isEqualToString:@"showRoomInfo"]){
             cell = (UITableViewCell *)[[[sender superview] superview] superview];
        }
        if([segue.identifier isEqualToString:@"showRoomInfo2"]){
            cell = (UITableViewCell *)sender;
        }
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        RoomViewController *ldvc = (RoomViewController *)segue.destinationViewController;
        TimeGridUnit *tgu = [_timeGridUnits objectAtIndex:indexPath.section];
        ldvc.room = [tgu.rooms objectAtIndex:indexPath.row];
        ldvc.currentDate = tgu.timeStart;
        
        
    }
    
    if([segue.identifier isEqualToString:@"bookTimeUnit"])
    {
        //get clicked cell
        UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        BoekenBevestigenViewController *bbvc = (BoekenBevestigenViewController *)segue.destinationViewController;
        TimeGridUnit *tgu = [_timeGridUnits objectAtIndex:indexPath.section];
        bbvc.startTime = tgu.timeStart;
        bbvc.endTime = tgu.timeEnd;
        bbvc.room = [tgu.rooms objectAtIndex:indexPath.row];
        
        
        
    }
    
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
