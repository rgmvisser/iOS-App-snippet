//
//  RoomViewController.h
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
@interface RoomViewController : UIViewController

@property (nonatomic,retain) Room *room;
@property (nonatomic,retain) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end
