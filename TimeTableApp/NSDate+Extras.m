//
//  NSDate+DayOnly.m
//  Timetable
//
//  Created by Ruud Visser on 04-07-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "NSDate+Extras.h"
#import "NSDateFormatter+Locale.h"
#import "AppSettings.h"

@implementation NSDate (Extras)

- (NSDate *)daySpecifick{
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:self];
    
    return [calendar dateFromComponents:components];    
}

- (BOOL)isSameDay:(NSDate *)otherDate{
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit
                                                      fromDate: [self daySpecifick]
                                                        toDate: [otherDate daySpecifick]
                                                       options: 0];
    
    NSInteger days = [components day];
    //DLog(@"First: %@ \n Second:%@ \n Days: %l",self,otherDate,days);
    return days == 0;
}

- (int)differenceInMinutesToDate:(NSDate *)otherDate
{
    NSTimeInterval secondsBetween = [otherDate timeIntervalSinceDate:self];
    
    int numberOfMinutes = secondsBetween / 60;
    
    return numberOfMinutes;
}

- (NSString *)yyyymmddFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithLocale];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:self];
    
}

+ (NSDate *)dateFromDictionary:(NSDictionary *)dict{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:[dict objectForKey:@"date"]];
    return date;
}


- (NSDate *)nextWeekDay{
    
    NSDate *nextWeekDay = self;
    while(true){
        nextWeekDay = [nextWeekDay dateByAddingTimeInterval:DAY];
        if([nextWeekDay isWeekDay])
        {
            return nextWeekDay;
        }
    }
    
}

- (NSDate *)previousWeekDay
{
    
    NSDate *previousWeekDay = self;
    while(true){
        previousWeekDay = [previousWeekDay dateByAddingTimeInterval:-DAY];
        //DLog(@"Previous: %@", previousWeekDay);
        if([previousWeekDay isWeekDay])
        {
            return previousWeekDay;
        }
    }
}

- (BOOL)isWeekDay{
    
    int dayInt = (int)[[[NSCalendar currentCalendar] components: NSWeekdayCalendarUnit fromDate: self] weekday];
    //DLog(@"Day: %d",dayInt);
    if(dayInt != 1 && dayInt != 7)
    {
        return YES;
    }else{
        return NO;
    }
    
    
}

@end
