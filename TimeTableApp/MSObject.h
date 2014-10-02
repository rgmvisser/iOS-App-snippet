//
//  MSObject.h
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSObject : NSObject

- (void)loadFromDictionary:(NSDictionary *)dict;

- (NSString *) notNullString:(NSString *)value;
- (NSNumber *) notNullNumber:(NSNumber *)value;

@end
