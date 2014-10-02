//
//  Timetable.m
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Timetable.h"
#import "Room.h"
#import "Course.h"
#import "Subject.h"
#import "Teacher.h"
#import "Student.h"
#import "NSDate+Extras.h"

@implementation Timetable

-(void)loadFromDictionary:(NSDictionary *)dict
{
    
    self.timetabelId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.periodId = [self notNullNumber:[dict objectForKey:@"period_id"]];
    self.userId = [self notNullNumber:[dict objectForKey:@"user_id"]];
    self.isConfirmed = [self notNullNumber:[dict objectForKey:@"is_confirmed"]];
    self.timeStart = [NSDate dateFromDictionary:[dict objectForKey:@"time_start"]];
    self.timeEnd = [NSDate dateFromDictionary:[dict objectForKey:@"time_end"]];
    
    //rooms
    NSMutableArray *rooms = [[NSMutableArray alloc] init];
    for (NSDictionary *roomData in [dict objectForKey:@"rooms"]) {
        
        Room *room = [[Room alloc] init];
        [room loadFromDictionary:roomData];
        [rooms addObject:room];
        
    }
    self.rooms = rooms;
    
    //courses
    NSMutableArray *courses = [[NSMutableArray alloc] init];
    for (NSDictionary *courseData in [dict objectForKey:@"courses"]) {
        
        Course *course = [[Course alloc] init];
        [course loadFromDictionary:courseData];
        [courses addObject:course];
    }
    self.courses = courses;
    
    //teachers
    NSMutableArray *teachers = [[NSMutableArray alloc] init];
    for (NSDictionary *teacherData in [dict objectForKey:@"teachers"]) {
        
        Teacher *teacher = [[Teacher alloc] init];
        [teacher loadFromDictionary:teacherData];
        [teachers addObject:teacher];
    }
    self.teachers = teachers;
    
    //subjects
    NSMutableArray *subjects = [[NSMutableArray alloc] init];
    for (NSDictionary *subjectData in [dict objectForKey:@"subjects"]) {
        
        Subject *subject = [[Subject alloc] init];
        [subject loadFromDictionary:subjectData];
        [subjects addObject:subject];
    }
    self.subjects = subjects;
    
    //students
    NSMutableArray *students = [[NSMutableArray alloc] init];
    for (NSDictionary *studentData in [dict objectForKey:@"students"]) {
        
        Student *student = [[Student alloc] init];
        [student loadFromDictionary:studentData];
        [students addObject:student];
    }
    self.students = students;
    
}


@end
