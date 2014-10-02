//
//  MSNetworking.h
//  Timetable
//
//  Created by Ruud Visser on 04-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import "AppDelegate.h"
#import "AppSettings.h"

@interface MSNetworking : AFHTTPRequestOperationManager

@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

+ (MSNetworking *)sharedMSClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)loadInformation;

-(void)registerStudent:(NSString *)username withSuccess:(void (^)(void))success;
-(void)registerTeacher:(NSString *)username withSuccess:(void (^)(void))success;
-(void)registerEmployee:(NSString *)username withSuccess:(void (^)(void))success;

-(void)loginWithSuccess:(void (^)(BOOL loggedIn))success;

-(void)getRooms:(NSNumber *)available onDate:(NSDate *)date withObjects:(NSArray *)objects withSuccess:(void (^)(NSArray *timeGridUnits))success;
-(void)getRoomTimeTable:(NSNumber *)roomId From:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSArray *timegrids))success;

-(void)getTimeTableFrom:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSArray *timegrids))success;

-(void)getNotificationswithSuccess:(void (^)(NSArray *notifications))success;

-(void)getBookingsWithSuccess:(void (^)(NSArray *timetable))success;
-(void)makeBookingForRooms:(NSArray *)rooms from:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSNumber *booked))success;
-(void)deleteBooking:(NSNumber *)timetableId withSuccess:(void (^)(void))success;

-(void)registerForSubject:(NSNumber *)subjectId withSuccess:(void (^)(void))success;
-(void)deRegisterForSubject:(NSNumber *)subjectId withSuccess:(void (^)(void))success;

-(void)registerNotificationTokenForUser:(NSString *)token withSuccess:(void (^)(void))success;

-(void)alert:(NSNumber *)alertId withMessage:(NSString *)message withSuccess:(void (^)(void))success;




@end
