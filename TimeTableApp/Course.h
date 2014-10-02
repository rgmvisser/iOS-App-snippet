//
//  Course.h
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSObject.h"

@interface Course : MSObject

@property (nonatomic, retain) NSNumber * timetableCourseId;
@property (nonatomic, retain) NSNumber * timetableId;
@property (nonatomic, retain) NSNumber * courseId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSNumber * active;

@end
