//
//  Subject.h
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MSObject.h"

@interface Subject : MSObject

@property (nonatomic, retain) NSNumber * timetableSubjectId;
@property (nonatomic, retain) NSNumber * timetableId;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * subjectDescription;
@property (nonatomic, retain) NSNumber * subjectId;


@end
