//
//  TimeGridUnit.m
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "TimeGridUnit.h"
#import "NSDate+Extras.h"
#import "Timetable.h"
#import "Room.h"

@implementation TimeGridUnit

-(void)loadFromDictionary:(NSDictionary *)dict
{
    self.timeGridUnitId = [self notNullNumber:[dict objectForKey:@"timegrid_unit_id"]];
    self.timeGridId = [self notNullNumber:[dict objectForKey:@"timegrid_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.timeStart = [NSDate dateFromDictionary:[dict objectForKey:@"time_start"]];
    self.timeEnd = [NSDate dateFromDictionary:[dict objectForKey:@"time_end"]];
    
    NSMutableArray *timetables = [[NSMutableArray alloc] init];
    for (NSDictionary *timetable in [dict objectForKey:@"timetables"]) {
        
        Timetable *tt = [[Timetable alloc] init];
        [tt loadFromDictionary:timetable];
        [timetables addObject:tt];
        
    }
    if([timetables count] < 1){
        Timetable *tt = [[Timetable alloc] init];
        tt.timeStart = self.timeStart;
        tt.timeEnd = self.timeEnd;
        tt.userId = 0;
        [timetables addObject:tt];
        
    }
    
    self.timetables = timetables;
}

-(void)loadRoomsFromDictionary:(NSDictionary *)dict
{
    
    self.timeGridUnitId = [self notNullNumber:[dict objectForKey:@"timegrid_unit_id"]];
    self.timeGridId = [self notNullNumber:[dict objectForKey:@"timegrid_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.timeStart = [NSDate dateFromDictionary:[dict objectForKey:@"time_start"]];
    self.timeEnd = [NSDate dateFromDictionary:[dict objectForKey:@"time_end"]];
    
    NSMutableArray *rooms = [[NSMutableArray alloc] init];
    for (NSDictionary *roomData in [dict objectForKey:@"rooms"]) {
        
        Room *room = [[Room alloc] init];
        [room loadFromDictionary:roomData];
        [rooms addObject:room];
        
    }
    self.rooms = rooms;

    
}

@end
