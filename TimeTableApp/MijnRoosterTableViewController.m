    //
//  MijnRoosterTableViewController.m
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MijnRoosterTableViewController.h"

//Custom Table Cell Views
#import "MRHeaderTableViewCell.h"
#import "MRInteractiveHeaderTableViewCell.h"
#import "MRNotificationTableViewCell.h"
#import "MRDateTableViewCell.h"
#import "MRRoosterItemTableViewCell.h"
#import "MSNetworking.h"
#import "Timetable.h"
#import "NSDateFormatter+Locale.h"
#import "NSDate+Extras.h"
#import "TimeGrid.h"
#import "TimeGridUnit.h"
#import "AppSettings.h"
#import "Notification.h"
#import "NotificationViewController.h"
#import "RoomsTableViewController.h"

@interface MijnRoosterTableViewController () <RoosterNavigateProtocol>
{
    NSArray *_notificationArray;
    NSMutableDictionary *_days;
    MRInteractiveHeaderTableViewCell *_roosterHeaderCell;
}

@property (nonatomic,strong) NSDate *currentDate;

@end

@implementation MijnRoosterTableViewController

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

    self.currentDate = [[NSDate alloc] init];
    if(![self.currentDate isWeekDay]){
        self.currentDate = [self.currentDate nextWeekDay];
    }
    _days = [[NSMutableDictionary alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _notificationArray = [Notification allObjectsOrderByIDDesc];
    [self loadTodayTimeTable];
    [self loadNotifications];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
    
    
    
}

- (void)loadNotifications
{
    [[MSNetworking sharedMSClient] getNotificationswithSuccess:^(NSArray *notifications) {
       
        _notificationArray = [Notification allObjectsOrderByIDDesc];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

- (void)loadTodayTimeTable
{
    [_days setObject:[NSNull null] forKey:self.currentDate];
    [_days setObject:[NSNull null] forKey:[self.currentDate nextWeekDay]];
    [_days setObject:[NSNull null] forKey:[self.currentDate previousWeekDay]];
    [self.tableView reloadData];
    [self getTimetableForDate:[self.currentDate previousWeekDay]];
    [self getTimetableForDate:self.currentDate];
    [self getTimetableForDate:[self.currentDate nextWeekDay]];
}

- (void)refresh:(id)sender
{
    _days = [[NSMutableDictionary alloc] init];
    [self loadTodayTimeTable];
    [self loadNotifications];
    [self performSelector:@selector(endRefresh:) withObject:sender afterDelay:0.3];
}

- (void)endRefresh:(id)sender
{
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)getTimetableForDate:(NSDate *)date
{
    //DLog(@"Get for date: %@",date);
    if([_days objectForKey:date] == [NSNull null])
    {
        [[MSNetworking sharedMSClient] getTimeTableFrom:date to:date withSuccess:^(NSArray *timegrids) {
            
            //@TODO sleep weg
            //sleep(1);
            
            for(TimeGrid *tg in timegrids){
                
                [_days removeObjectForKey:date];
                [_days setObject:tg forKey:date];
                [self.tableView reloadData];
            }
            if([timegrids count] == 0){  // if day is empty, safe an empty timegrid
                [_days removeObjectForKey:date];
                [_days setObject:[[TimeGrid alloc] init] forKey:date];
                [self.tableView reloadData];
            }
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            MRHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRHeaderTableViewCell"];
            [cell.titleLabel setText:@"NOTIFICATIES"];
            //hack tegen bug
            CGRect frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            [cell setFrame:frame];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            [view addSubview:cell];
            //
            return view;
            break;
        }
        case 1:{
            _roosterHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"MRInteractiveHeaderTableViewCell"];
            _roosterHeaderCell.delegate = self;
            if(![[AppSettings sharedInstance] isEmployee]){
                [_roosterHeaderCell.titleLabel setText:@"ROOSTER"];
            }else{
                [_roosterHeaderCell.titleLabel setText:@"BOEKINGEN  "];
            }
            //hack tegen bug
            CGRect frame = CGRectMake(0, 0, _roosterHeaderCell.frame.size.width, _roosterHeaderCell.frame.size.height);
            [_roosterHeaderCell setFrame:frame];
            UIView *view = [[UIView alloc] initWithFrame:frame];
            [view addSubview:_roosterHeaderCell];
            //
            return view;
            break;
        }
        default:{
            return [[UIView alloc] init];
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section){
        case 0:
            if([_notificationArray count] ==0){
                return 1;
            }
            return _notificationArray.count;
            break;
        case 1:
        {
            // Return the number of rows in the section.
            if([_days objectForKey:self.currentDate] != [NSNull null])
            {
                TimeGrid *tg = (TimeGrid *)[_days objectForKey:self.currentDate];
                return [tg totalAmountOfTimeTables]+1;
            }else{
                return 1; // loading
            }
        }
        default:return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 44;
    switch (indexPath.section) {
        case 0:{
            height = 55;
            break;
        }
        case 1:{
            //loading
            if([_days objectForKey:self.currentDate] == [NSNull null]){
                return 55;
            }
            if(indexPath.row == 0){
                height = 34; //date row
            }else{
                height = 66;
            }
            break;
        }
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"Section: %ld, Row: %ld", (long)indexPath.section, (long)indexPath.row);
    
    
    
    NSString *identifier;
    
    
    switch (indexPath.section) {
        case 0:{
            
            if([_notificationArray count] == 0){
                
                NSString *identifier = @"loadTableViewCell";
                MRRoosterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                [cell.bottomLabel setText:@"Notificaties laden"];
                return cell;
            }
            //DLog(@"Making notification row");
            identifier = @"MRNotificationTableViewCell";
            MRNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            Notification *notification = [_notificationArray objectAtIndex:[indexPath row]];
            [cell.contentLabel setText:notification.name];
            return cell;
            break;
        }
        case 1:{
            if([_days objectForKey:self.currentDate] == [NSNull null])
            {
                NSString *identifier = @"loadTableViewCell";
                MRRoosterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                [cell.bottomLabel setText:@"Rooster laden"];
                return cell;
            }
            
            if(indexPath.row == 0){
                //DLog(@"Making date row");

                identifier = @"MRDateTableViewCell";
                MRDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                TimeGrid *tg = [_days objectForKey:self.currentDate];
                TimeGridUnit *tgu = [tg.timeGridUnits objectAtIndex:0];
                NSString *startString = [NSDateFormatter dateStringFromDate:tgu.timeStart];
                [cell.dateLabel setText: startString];
                [cell.weekLabel setText:tg.name];
                return cell;
            }else{
                //DLog(@"Making rooster item row");

                identifier = @"MRRoosterItemTableViewCell";
                MRRoosterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                TimeGrid *tg = (TimeGrid *)[_days objectForKey:self.currentDate];
                Timetable *tt = [tg getTimetableAtIndex:(indexPath.row-1)];
                
                NSString *startString = [NSDateFormatter timeStringFromDate:tt.timeStart];
                NSString *endString = [NSDateFormatter timeStringFromDate:tt.timeEnd];
                
                [cell.startLabel setText:startString];
                [cell.endLabel setText:endString];
                NSArray *coursesAndSubjects = [[NSArray arrayWithArray:tt.courses] arrayByAddingObjectsFromArray:tt.subjects];
                if([coursesAndSubjects count] > 0 || [tt.teachers count] > 0){
                    [cell.topLabel setText:[NSString stringWithFormat:@"%@ - %@",[coursesAndSubjects componentsJoinedByString:@","],[tt.teachers componentsJoinedByString:@","]]];
                }else{
                    if([[AppSettings sharedInstance] isUserBooking:tt.userId]){
                        [cell.topLabel setText:@"Boeking"];
                    }else{
                        [cell.topLabel setText:@"-"];
                    }
                    
                }
                [cell.bottomLabel setText: [tt.rooms componentsJoinedByString:@","]];
               
                if([[AppSettings sharedInstance] isUserBooking:tt.userId]){
                    [cell setBackgroundColor:Timetable_ORANGE];
                }else{
                    [cell setBackgroundColor:Timetable_LIGHT_BLUE];
                }
                
                if([[AppSettings sharedInstance] isTeacher] && [tt.rooms count] > 0)
                {
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                }else{
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
                
                
                return cell;
            }
            break;
        }
        default:{
            return [[UITableViewCell alloc] init];
            break;
        }
    }
    
}


- (void)previousDay {
    
    NSArray *oldindeces = [self getIndecesOfRows];
    
    self.currentDate = [self.currentDate previousWeekDay];
    
    NSArray *newindeces = [self getIndecesOfRows];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getTimetableForDate:self.currentDate];
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:newindeces withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView deleteRowsAtIndexPaths:oldindeces withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *previousDay = [self.currentDate previousWeekDay];
    if(![_days objectForKey:previousDay])
    {
        [_days setObject:[NSNull null] forKey:previousDay];
        [self getTimetableForDate:previousDay];
        
    }
    
    
}

- (void)previousWeek{
    
    NSArray *oldindeces = [self getIndecesOfRows];
    
    self.currentDate = [self.currentDate dateByAddingTimeInterval:-WEEK];
    
    NSArray *newindeces = [self getIndecesOfRows];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getTimetableForDate:self.currentDate];
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:newindeces withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView deleteRowsAtIndexPaths:oldindeces withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *previousDay = [self.currentDate previousWeekDay];
    if(![_days objectForKey:previousDay])
    {
        [_days setObject:[NSNull null] forKey:previousDay];
        [self getTimetableForDate:previousDay];
        
    }
    
}


- (void)nextDay {
    
    NSArray *oldindeces = [self getIndecesOfRows];
    
    self.currentDate = [self.currentDate nextWeekDay];
    
    NSArray *newindeces = [self getIndecesOfRows];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getTimetableForDate:self.currentDate];
        
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:newindeces withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteRowsAtIndexPaths:oldindeces withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *nextDay = [self.currentDate nextWeekDay];
    if(![_days objectForKey:nextDay])
    {
        [_days setObject:[NSNull null] forKey:nextDay];
        [self getTimetableForDate:nextDay];
        
    }
    
}

- (void)nextWeek{
    
    NSArray *oldindeces = [self getIndecesOfRows];
    
    self.currentDate = [self.currentDate dateByAddingTimeInterval:WEEK];
    
    NSArray *newindeces = [self getIndecesOfRows];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getTimetableForDate:self.currentDate];
        
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:newindeces withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteRowsAtIndexPaths:oldindeces withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *nextDay = [self.currentDate nextWeekDay];
    if(![_days objectForKey:nextDay])
    {
        [_days setObject:[NSNull null] forKey:nextDay];
        [self getTimetableForDate:nextDay];
        
    }
    
    
}



- (NSArray *)getIndecesOfRows
{
    NSMutableArray *indeces = [[NSMutableArray alloc] init];
    int amountOfRows = (int)[self tableView:self.tableView numberOfRowsInSection:1];
    for (int i = 0; i < amountOfRows; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:1];
        [indeces addObject:ip];
    }
    return indeces;
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"showBooking"]){
     
        if([[AppSettings sharedInstance] isTeacher]){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"showNotification"]){
        
        NotificationViewController *nvc = (NotificationViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        nvc.notification = [_notificationArray objectAtIndex:indexPath.row];
        
    }else if ([segue.identifier isEqualToString:@"showBooking"]){
        
        RoomsTableViewController *rtvc = (RoomsTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TimeGrid *tg = (TimeGrid *)[_days objectForKey:self.currentDate];
        Timetable *tt = [tg getTimetableAtIndex:(indexPath.row-1)];
        rtvc.booking = tt;
    }
    
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
