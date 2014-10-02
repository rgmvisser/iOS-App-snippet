//
//  Student.h
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MSObject.h"

@interface Student : MSObject

@property (nonatomic, retain) NSNumber * timetableStudentId;
@property (nonatomic, retain) NSNumber * timetableId;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * forename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * studentDescription;
@property (nonatomic, retain) NSNumber * studentId;

@end
