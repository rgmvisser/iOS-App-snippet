//
//  NSDateFormatter+Locale.h
//  Timetable
//
//  Created by Ruud Visser on 08-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Locale)

- (id)initWithLocale;
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSString *)timeStringFromDate:(NSDate *)date;
@end
