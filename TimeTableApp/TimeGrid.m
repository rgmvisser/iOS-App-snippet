//
//  TimeGrid.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "TimeGrid.h"
#import "TimeGridUnit.h"
@implementation TimeGrid

-(void)loadFromDictionary:(NSDictionary *)dict
{
    self.timeGridId = [self notNullNumber:[dict objectForKey:@"timegrid_id"]];
    self.date = [dict objectForKey:@"date"];
    self.name = [self notNullString:[dict objectForKey:@"name"]];
    NSMutableArray *timeGridUnits = [[NSMutableArray alloc] init];
    for (NSDictionary *timeGridUnit in [dict objectForKey:@"timegrid_units"]) {
        
        TimeGridUnit *tgu = [[TimeGridUnit alloc] init];
        [tgu loadFromDictionary:timeGridUnit];
        [timeGridUnits addObject:tgu];
    
    }
    
    self.timeGridUnits = timeGridUnits;
}

- (int)totalAmountOfTimeTables{
    
    int total = 0;
    for(TimeGridUnit *tgu in self.timeGridUnits){
        total += [tgu.timetables count];
    }
    return total;
    
}

-(Timetable *)getTimetableAtIndex:(NSInteger)index{
    
    assert([self totalAmountOfTimeTables] > index);

    NSInteger currentIndex = index;
    int currentGridUnit = 0;
    while(true){
        
        TimeGridUnit *tgu = [self.timeGridUnits objectAtIndex:currentGridUnit];
        int amountOfTimetables = (int)[tgu.timetables count];
        if(currentIndex >= amountOfTimetables)
        {
            currentIndex -= amountOfTimetables;
        
        }else{
            
            return [tgu.timetables objectAtIndex:currentIndex];
            
        }
        currentGridUnit++;
    }
    
    return nil;
}


- (void)deleteTimetableAtIndex:(NSInteger)index{
    assert([self totalAmountOfTimeTables] > index);
    
    NSInteger currentIndex = index;
    int currentGridUnit = 0;
    while(true){
        
        TimeGridUnit *tgu = [self.timeGridUnits objectAtIndex:currentGridUnit];
        int amountOfTimetables = (int)[tgu.timetables count];
        if(currentIndex >= amountOfTimetables)
        {
            currentIndex -= amountOfTimetables;
            
        }else{
            NSMutableArray *timetables = [tgu.timetables mutableCopy];
            [timetables removeObjectAtIndex:currentIndex];
            tgu.timetables = timetables;
            return;
            
        }
        currentGridUnit++;
    }
}

@end
