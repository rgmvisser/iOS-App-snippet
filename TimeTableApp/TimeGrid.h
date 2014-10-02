//
//  TimeGrid.h
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSObject.h"
#import "Timetable.h"

@interface TimeGrid : MSObject

@property (nonatomic, retain) NSNumber * timeGridId;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, retain) NSArray * timeGridUnits;

- (int) totalAmountOfTimeTables;
- (Timetable *)getTimetableAtIndex:(NSInteger)index;
- (void)deleteTimetableAtIndex:(NSInteger)index;

@end
