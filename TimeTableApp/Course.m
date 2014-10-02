//
//  Course.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Course.h"

@implementation Course

-(void)loadFromDictionary:(NSDictionary *)dict{
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.courseDescription = [self notNullString:[dict objectForKey:@"description"]];
    self.courseId = [self notNullNumber:[dict objectForKey:@"room_id"]];
    self.timetableCourseId = [self notNullNumber:[dict objectForKey:@"timetable_course_id"]];
    self.timetableId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.active = [self notNullNumber:[dict objectForKey:@"active"]];
}

- (NSString *)description{
    return self.name;
}

@end
