//
//  Timetable.h
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSObject.h"

@interface Timetable : MSObject

@property (nonatomic, retain) NSNumber * timetabelId;
@property (nonatomic, retain) NSNumber * periodId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * isConfirmed;
@property (nonatomic, retain) NSDate * timeStart;
@property (nonatomic, retain) NSDate * timeEnd;
@property (nonatomic, retain) NSArray * rooms;
@property (nonatomic, retain) NSArray * teachers;
@property (nonatomic, retain) NSArray * subjects;
@property (nonatomic, retain) NSArray * courses;
@property (nonatomic, retain) NSArray * students;


@end
