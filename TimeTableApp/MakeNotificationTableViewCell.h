//
//  MakeNotificationTableViewCell.h
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstellingenViewController.h"
#import "DropDownButton.h"
@class BlueButton;
@interface MakeNotificationTableViewCell : UITableViewCell

@property (nonatomic,retain) NSArray *allNotifications;

@property (weak, nonatomic) IBOutlet DropDownButton *selectNotification;
@property (weak, nonatomic) IBOutlet BlueButton *notifyButton;

@property (weak, nonatomic) UIViewController<NotificationProtocol> *delegate;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextview;

@end
