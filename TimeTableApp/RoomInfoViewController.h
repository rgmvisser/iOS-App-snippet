//
//  RoomInfoViewController.h
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLabel.h"
#import "Room.h"
@interface RoomInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet MSLabel *roomName;
@property (weak, nonatomic) IBOutlet MSLabel *roomDescription;
@property (weak, nonatomic) IBOutlet MSLabel *roomLocation;

@property (weak, nonatomic) IBOutlet UIScrollView *extraScrollview;

@property (nonatomic,retain) Room *room;
@end
