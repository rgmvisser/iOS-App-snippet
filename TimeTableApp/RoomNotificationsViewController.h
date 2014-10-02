//
//  RoomNotificationsViewController.h
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueButton.h"
#import "DropDownButton.h"
#import "Room.h"

@interface RoomNotificationsViewController : UIViewController

@property (weak, nonatomic) IBOutlet DropDownButton *notificationDropdown;
@property (weak, nonatomic) IBOutlet BlueButton *makeNotificationButton;

@property (nonatomic, retain) Room *room;

@property (weak, nonatomic) IBOutlet UITextView *remarkTextfield;

@end
