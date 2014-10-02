//
//  SubjectTableViewCell.h
//  TimetableApp
//
//  Created by Ruud Visser on 07-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject2.h"
#import "MSLabel.h"
#import "InstellingenViewController.h"
@interface SubjectTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SubjectProtocol> delegate;

@property (weak, nonatomic) IBOutlet MSLabel *subjectName;
@property (weak, nonatomic) Subject2 *subject;

@end
