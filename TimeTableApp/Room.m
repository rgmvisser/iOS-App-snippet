//
//  Room.m
//  Timetable
//
//  Created by Ruud Visser on 05-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "Room.h"


@implementation Room

- (NSString *)description{
    return self.name;
}

-(void)loadFromDictionary:(NSDictionary *)dict{
    
    self.timetableRoomId = [self notNullNumber:[dict objectForKey:@"timetable_room_id"]];
    self.timetableId = [self notNullNumber:[dict objectForKey:@"timetable_id"]];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    self.roomDescription = [self notNullString:[dict objectForKey:@"description"]];
    self.roomId = [self notNullNumber:[dict objectForKey:@"room_id"]];
    self.building = [self notNullString:[dict objectForKey:@"building"]];
    self.active = [self notNullNumber:[dict objectForKey:@"active"]];
}

@end
