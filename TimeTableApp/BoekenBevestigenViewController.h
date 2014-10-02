//
//  BoekenBevestigenViewController.h
//  Timetable
//
//  Created by Mark Ramakers on 20/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeGridUnit.h"
#import "Room.h"
@interface BoekenBevestigenViewController : UIViewController


@property (nonatomic,retain) NSDate *startTime;
@property (nonatomic,retain) NSDate *endTime;

@property (nonatomic,retain) Room *room;


@end
