//
//  NSDate+Extras.h
//  Timetable
//
//  Created by Ruud Visser on 04-07-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extras)

- (NSDate *)daySpecifick;
- (BOOL)isSameDay:(NSDate *)otherDate;
- (int)differenceInMinutesToDate:(NSDate *)otherDate;
- (NSString *)yyyymmddFormat;


+ (NSDate *)dateFromDictionary:(NSDictionary *)dict;
- (NSDate *)nextWeekDay;
- (NSDate *)previousWeekDay;
- (BOOL)isWeekDay;

@end
