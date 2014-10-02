//
//  LokaalDetailViewController.m
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "RoomListViewController.h"

//Custom Table Cell Views
#import "LKLokaalTableViewCell.h"
#import "MSButton.h"
#import "MSLabel.h"
#import "NSDate+Extras.h"
#import "NSDateFormatter+Locale.h"
#import "MSNetworking.h"
#import "TimeGrid.h"
#import "BoekenBevestigenViewController.h"
#import "TimeGridUnit.h"

@interface RoomListViewController ()
{
    NSMutableDictionary *_days;
}

@property (weak, nonatomic) IBOutlet MSLabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;


@end

@implementation RoomListViewController

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
    _days = [[NSMutableDictionary alloc] init];
    if(![self.currentDate isWeekDay]){
        [self.currentDate nextWeekDay];
    }
    [self setTitle:self.room.name];
    [self updateCurrentDay];
    
    //load today, yesterday and tomorrow
    [self loadTodayRoom];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self.tableView addSubview:refreshControl];
}

- (void)loadTodayRoom
{
    [_days setObject:[NSNull null] forKey:self.currentDate];
    [_days setObject:[NSNull null] forKey:[self.currentDate previousWeekDay]];
    [_days setObject:[NSNull null] forKey:[self.currentDate nextWeekDay]];
    [self.tableView reloadData];
    [self getRoomTimetableForDate:[self.currentDate previousWeekDay]];
    [self getRoomTimetableForDate:self.currentDate];
    [self getRoomTimetableForDate:[self.currentDate nextWeekDay]];
}

- (void)refresh:(id)sender
{
    _days = [[NSMutableDictionary alloc] init];
    [self loadTodayRoom];
    [self performSelector:@selector(endRefresh:) withObject:sender afterDelay:0.3];
}

- (void)endRefresh:(id)sender
{
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)getRoomTimetableForDate:(NSDate *)date
{
    //DLog(@"Get for date: %@",date);
    if([_days objectForKey:date] == [NSNull null])
    {
        [[MSNetworking sharedMSClient] getRoomTimeTable:self.room.roomId From:date to:date withSuccess:^(NSArray *timegrids) {
            
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

- (void)updateCurrentDay{
    
    [self.currentDateLabel setText:[NSDateFormatter dateStringFromDate:self.currentDate]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([_days objectForKey:self.currentDate] != [NSNull null])
    {
        TimeGrid *tg = (TimeGrid *)[_days objectForKey:self.currentDate];
        return [tg totalAmountOfTimeTables];
    }else{
        return 1; // loading
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_days objectForKey:self.currentDate] == [NSNull null]){
        return 54;
    }
    return 66;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_days objectForKey:self.currentDate] == [NSNull null])
    {
        NSString *identifier = @"searchTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cell;
    }
    
    TimeGrid *tg = (TimeGrid *)[_days objectForKey:self.currentDate];
    Timetable *tt = [tg getTimetableAtIndex:indexPath.row];
    NSString *identifier = @"LKLokaalTableViewCell";
    LKLokaalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray *coursesAndSubjects = [[NSArray arrayWithArray:tt.courses] arrayByAddingObjectsFromArray:tt.subjects];
    if([tt.teachers count] > 0 || [tt.students count] >0){
        [cell.topLabel setText:[NSString stringWithFormat:@"%@",[[tt.teachers arrayByAddingObjectsFromArray:tt.students] componentsJoinedByString:@","]]];
    }else{
        [cell.topLabel setText:@"-"];
    }
    [cell.bottomLabel setText: [coursesAndSubjects componentsJoinedByString:@","]];
    [cell.beginTijd setText:[NSDateFormatter timeStringFromDate:tt.timeStart]];
    [cell.eindTijd setText:[NSDateFormatter timeStringFromDate:tt.timeEnd]];
    if(tt.timetabelId != nil)
    {
        [cell setRoomAvailibility:NO];
    }else{
        [cell setRoomAvailibility:YES];
    }
    
    return cell;
}

- (IBAction)nextDay:(id)sender {
    
    
    self.currentDate = [self.currentDate nextWeekDay];
    [self updateCurrentDay];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getRoomTimetableForDate:self.currentDate];
        
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *nextDay = [self.currentDate nextWeekDay];
    if(![_days objectForKey:nextDay])
    {
        [_days setObject:[NSNull null] forKey:nextDay];
        [self getRoomTimetableForDate:nextDay];
        
    }
    
    

}
- (IBAction)nextWeek:(id)sender {
    
    self.currentDate = [self.currentDate dateByAddingTimeInterval:WEEK];
    [self updateCurrentDay];
    
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getRoomTimetableForDate:self.currentDate];
        
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *nextDay = [self.currentDate nextWeekDay];
    if(![_days objectForKey:nextDay])
    {
        [_days setObject:[NSNull null] forKey:nextDay];
        [self getRoomTimetableForDate:nextDay];
        
    }
    
    
}
- (IBAction)previousDay:(id)sender {
    
    self.currentDate = [self.currentDate previousWeekDay];
    [self updateCurrentDay];
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getRoomTimetableForDate:self.currentDate];
    }
    [self.tableView beginUpdates];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *previousDay = [self.currentDate previousWeekDay];
    if(![_days objectForKey:previousDay])
    {
        [_days setObject:[NSNull null] forKey:previousDay];
        [self getRoomTimetableForDate:previousDay];
        
    }
    
}
- (IBAction)previousWeek:(id)sender {
    
    self.currentDate = [self.currentDate dateByAddingTimeInterval:-WEEK];
    [self updateCurrentDay];
    if(![_days objectForKey:self.currentDate])
    {
        [_days setObject:[NSNull null] forKey:self.currentDate];
        [self getRoomTimetableForDate:self.currentDate];
    }
    [self.tableView beginUpdates];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    //also already load the next day
    NSDate *previousDay = [self.currentDate previousWeekDay];
    if(![_days objectForKey:previousDay])
    {
        [_days setObject:[NSNull null] forKey:previousDay];
        [self getRoomTimetableForDate:previousDay];
        
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    TimeGrid *tg = [_days objectForKey:self.currentDate];
    Timetable *tt = [tg getTimetableAtIndex:indexPath.row];
    return tt.timetabelId == nil; //check if slot is empty or not
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"bookRoom"]){

        
        BoekenBevestigenViewController *bbvc = (BoekenBevestigenViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        TimeGrid *tg = [_days objectForKey:self.currentDate];
        Timetable *tt = [tg getTimetableAtIndex:indexPath.row];
        bbvc.startTime = tt.timeStart;
        bbvc.endTime = tt.timeEnd;
        bbvc.room = self.room;
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
