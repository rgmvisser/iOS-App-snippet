//
//  VrijeLokalenViewController.h
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "WelcomeViewController.h"

@interface VrijeLokalenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSNumber *showOnlyFreeRooms;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSArray *selectedObjects;

@end
