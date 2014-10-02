//
//  Room.h
//  Timetable
//
//  Created by Ruud Visser on 05-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSObject.h"

@interface Room : MSObject

//@TODO maybe add additional information?
@property (nonatomic, retain) NSNumber * timetableRoomId;
@property (nonatomic, retain) NSNumber * timetableId;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * roomDescription;
@property (nonatomic, retain) NSNumber * roomId;



@end
