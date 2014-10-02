//
//  Teacher.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

-(void)loadFromDictionary:(NSDictionary *)dict{
    
    self.timetableTeacherId = [self notNullNumber:[dict objectForKey:@"timetable_teacher_id"]];
    self.timetableId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.teacherDescription = [self notNullString:[dict objectForKey:@"description"]];
    self.teacherId = [self notNullNumber:[dict objectForKey:@"teacher_id"]];
    self.forename = [self notNullString:[dict objectForKey:@"forename"]];
    self.active = [self notNullNumber:[dict objectForKey:@"active"]];
}

- (NSString *)description{
    return self.name;
}

@end
