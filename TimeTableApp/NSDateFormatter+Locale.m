//
//  NSDateFormatter+Locale.m
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "NSDateFormatter+Locale.h"


@implementation NSDateFormatter (Locale)

- (id)initWithLocale {
    self = [self init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"];
    [self setLocale:locale];
    return self;
}

+ (NSString *)dateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] initWithLocale];
    
    [df setDateFormat:@"dd MMMM YYYY"];
    return [df stringFromDate:date];
}

+(NSString *)timeStringFromDate:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] initWithLocale];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end
