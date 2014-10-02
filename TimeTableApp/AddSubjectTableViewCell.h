//
//  AddSubjectTableViewCell.h
//  Timetableapp
//
//  Created by Ruud Visser on 10-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownButton.h"
#import "BlueButton.h"
#import "InstellingenViewController.h"

@interface AddSubjectTableViewCell : UITableViewCell

@property (nonatomic,retain) NSArray *allSubjects;
@property (nonatomic,retain) NSMutableArray *subscriptions;

@property (weak, nonatomic) IBOutlet DropDownButton *selectClassDropDown;
@property (weak, nonatomic) IBOutlet BlueButton *subscribeButton;

@property (weak, nonatomic) UIViewController<SubjectProtocol> *delegate;

- (void) refresh;

@end
