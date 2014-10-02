//
//  LokaalDetailViewController.h
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "WelcomeViewController.h"

//Custom Table Cell Views

#import "LKLokaalTableViewCell.h"
#import "Room.h"
@interface RoomListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) Room *room;
@property (nonatomic,retain) NSDate *currentDate;


@end
