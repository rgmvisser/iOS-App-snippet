//
//  ZoekEnBoekViewController.h
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSButton.h"
#import "DropDownButton.h"

@interface ZoekEnBoekViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *vrijeLokalenRadioButton;
@property (weak, nonatomic) IBOutlet UIButton *alleLokalenRadioButton;
@property (weak, nonatomic) IBOutlet DropDownButton *locationPickButton;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


- (IBAction)CheckboxButtonPressed:(id)sender;
- (IBAction)radioButtonPressed:(id)sender;
@end
