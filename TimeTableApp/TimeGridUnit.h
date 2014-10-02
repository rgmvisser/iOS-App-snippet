//
//  TimeGridUnit.h
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSObject.h"
@interface TimeGridUnit : MSObject

@property (nonatomic, retain) NSNumber * timeGridUnitId;
@property (nonatomic, retain) NSNumber * timeGridId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStart;
@property (nonatomic, retain) NSDate * timeEnd;
@property (nonatomic, retain) NSArray * timetables;
@property (nonatomic, retain) NSArray * rooms;

- (void)loadRoomsFromDictionary:(NSDictionary *)dict;


@end
