//
//  MSObject.m
//  Timetable
//
//  Created by Ruud Visser on 20-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MSObject.h"

@implementation MSObject

- (void)loadFromDictionary:(NSDictionary *)dict{
    
    [NSException raise:@"Load dictionary method is not implemented" format:nil];
    
}


- (NSString *) notNullString:(NSString *)value
{
    if ([value isKindOfClass:[NSNull class]] || !value)
    {
        return @"";
    }
    else
    {
        return value;
    }
}

- (NSNumber *) notNullNumber:(NSNumber *)value
{
    if ([value isKindOfClass:[NSNull class]] || !value)
    {
        return [NSNumber numberWithInt:0];
    }
    else
    {
        return value;
    }
}


@end
