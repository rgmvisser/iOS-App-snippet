//
//  Subject.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Subject.h"

@implementation Subject

-(void)loadFromDictionary:(NSDictionary *)dict{
    
    self.timetableSubjectId = [self notNullNumber:[dict objectForKey:@"timetable_subject_id"]];
    self.timetableId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.subjectDescription = [self notNullString:[dict objectForKey:@"description"]];
    self.subjectId = [self notNullNumber:[dict objectForKey:@"subject_id"]];
    self.active = [self notNullNumber:[dict objectForKey:@"active"]];
}

- (NSString *)description{
    return self.name;
}

@end
