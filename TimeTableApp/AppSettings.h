//
//  AppSettings.h
//  Timetable
//
//  Created by Ruud Visser on 30-06-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

@interface AppSettings : NSObject

@property (nonatomic) BOOL isStillLoggedIn;
/**
 * gets singleton object.
 * @return singleton
 */
+ (AppSettings*)sharedInstance;

#define DAY 60*60*24
#define WEEK DAY*7

#define STUDENT [NSNumber numberWithInt:1]
#define TEACHER [NSNumber numberWithInt:2]
#define EMPLOYEE [NSNumber numberWithInt:3]

#define RADIANSFROMDEGREE(degrees) ((degrees * M_PI) / 180.0)

#define Timetable_BLUE [UIColor colorWithRed:18/255.0 green:135/255.0 blue:198/255.0 alpha:1.0]
#define Timetable_LIGHT_BLUE [UIColor colorWithRed:223/255.0 green:242/255.0 blue:248/255.0 alpha:1.0]
#define Timetable_SAND [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]
#define Timetable_ORANGE [UIColor colorWithRed:243/255.0 green:158/255.0 blue:94/255.0 alpha:1.0]
#define Timetable_YELLOW [UIColor colorWithRed:255/255.0 green:255/255.0 blue:204/255.0 alpha:1.0]



#define MS_REGULAR_FONT @"PTSans-Regular"
#define MS_BOLD_FONT @"PTSans-Bold"
#define MS_ITALIC_FONT @"PTSans-Italic"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

- (UIFont *)regularFontWithFontSize:(CGFloat) size;
- (UIFont *)boldFontWithFontSize:(CGFloat) size;
- (UIFont *)italicFontWithFontSize:(CGFloat) size;

- (BOOL)isRegistered;
- (BOOL)isLoggedIn;
- (BOOL)isStudent;
- (BOOL)isTeacher;
- (BOOL)isEmployee;
- (NSString *)getToken;
- (NSString *)getUsername;
- (BOOL)isUserBooking:(NSNumber *)bookingUserId;
- (void)setLoginInformation:(NSString *)username password:(NSString *)password type:(NSNumber *)type;
- (void)storeAdditionalUserInformation:(NSNumber *)userId studentId:(NSNumber *)studentId teacherId:(NSNumber *)teacherId email:(NSString *)email;
- (void)setSubjectSubscriptions:(NSMutableArray *)subjectSubscriptions;
- (NSMutableArray *)getSubjectSubscriptions;
- (void)logoutUser;

- (void)askForNotifications;


@end
