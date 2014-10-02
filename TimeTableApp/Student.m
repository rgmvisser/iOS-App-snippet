//
//  Student.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Student.h"

@implementation Student

-(void)loadFromDictionary:(NSDictionary *)dict{
    
    self.timetableStudentId = [self notNullNumber:[dict objectForKey:@"timetable_student_id"]];
    self.timetableId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.studentDescription = [self notNullString:[dict objectForKey:@"description"]];
    self.studentId = [self notNullNumber:[dict objectForKey:@"student_id"]];
    self.forename = [self notNullString:[dict objectForKey:@"forename"]];
    self.active = [self notNullNumber:[dict objectForKey:@"active"]];
}

- (NSString *)description{
    //@TODO what must be the description of a student?
    return self.studentDescription;
}

@end
