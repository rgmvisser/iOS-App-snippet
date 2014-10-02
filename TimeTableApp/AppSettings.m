//
//  AppSettings.m
//  Timetable
//
//  Created by Ruud Visser on 30-06-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "AppSettings.h"
#import "AppDelegate.h"
#import "Subject2.h"
#import "Alert.h"
#import "GeneralAlert.h"
#import "RoomAlert.h"
#import "Room2.h"
#import "Notification.h"

@implementation AppSettings

static AppSettings *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
        [SINGLETON setDefaults];
    });
    
    return SINGLETON;
}

#pragma mark - Login settings


- (BOOL)isRegistered
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"] == nil || [defaults objectForKey:@"password"] == nil){
        DLog(@"Credentials not yet stored");
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userId"] == nil){
        DLog(@"No userid known");
        return NO;
    }else{
        return YES;
    }
}


- (void)setLoginInformation:(NSString *)username password:(NSString *)password type:(NSNumber *)type{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:password forKey:@"password"];
    [defaults setObject:type forKey:@"type"];
    [defaults synchronize];
    
}

- (void)setSubjectSubscriptions:(NSMutableArray *)subjectSubscriptions{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:subjectSubscriptions forKey:@"subjectSubscriptions"];
    [defaults synchronize];
}

- (NSMutableArray *)getSubjectSubscriptions{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"subjectSubscriptions"] == nil){
        return [[NSMutableArray alloc] init];
    }else{
        return [[defaults objectForKey:@"subjectSubscriptions"] mutableCopy];
    }
    
}


- (void)storeAdditionalUserInformation:(NSNumber *)userId studentId:(NSNumber *)studentId teacherId:(NSNumber *)teacherId email:(NSString *)email
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:@"userId"];
    [defaults setObject:studentId forKey:@"studentId"];
    [defaults setObject:teacherId forKey:@"teacherId"];
    [defaults setObject:email forKey:@"email"];
    [defaults synchronize];
}

- (BOOL)isStudent
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"type"] == nil){
        DLog(@"Credentials not yet stored");
        return NO;
    }else{
        if([[defaults objectForKey:@"type"] isEqualToNumber:STUDENT])
        {
            return YES;
        }else{
            return NO;
        }
    }
}
- (BOOL)isTeacher
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"type"] == nil){
        DLog(@"Credentials not yet stored");
        return NO;
    }else{
        if([[defaults objectForKey:@"type"] isEqualToNumber:TEACHER])
        {
            return YES;
        }else{
            return NO;
        }
    }
}
- (BOOL)isEmployee
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"type"] == nil){
        DLog(@"Credentials not yet stored");
        return NO;
    }else{
        if([[defaults objectForKey:@"type"] isEqualToNumber:EMPLOYEE])
        {
            return YES;
        }else{
            return NO;
        }
    }
}

- (BOOL)isUserBooking:(NSNumber *)bookingUserId
{
    if([bookingUserId isKindOfClass:[NSNull class]] || !bookingUserId){
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userId"] == nil){
        DLog(@"Credentials not yet stored");
        return NO;
    }else{
        if([[defaults objectForKey:@"userId"] isEqualToNumber:bookingUserId])
        {
            return YES;
        }else{
            return NO;
        }
    }
    
}

- (NSString *)getUsername{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"] == nil){
        DLog(@"Username not yet stored");
        return @"";
    }else{
        return [defaults objectForKey:@"username"];
    }
    
}

- (NSString *)getToken{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"password"] == nil){
        DLog(@"Token not yet stored");
        return @"";
    }else{
        return [defaults objectForKey:@"password"];
    }
}

- (void)logoutUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"type"];
    [defaults removeObjectForKey:@"studentId"];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"teacherId"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"subjectSubscriptions"];
    [defaults synchronize];
    [Subject2 deleteAllObjects];
    [Alert deleteAllObjects];
    [Room2 deleteAllObjects];
    [GeneralAlert deleteAllObjects];
    [RoomAlert deleteAllObjects];
    [Notification deleteAllObjects];
    
    
}

- (void)askForNotifications{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeAlert |
    UIRemoteNotificationTypeSound];
}

#pragma mark - Default Functions

- (void) setDefaults
{
    [self setDefaultNavigationAppearance];
    
}

- (void) setDefaultNavigationAppearance
{
    //Custom navigation bar
    [[UINavigationBar appearance] setBarTintColor:Timetable_BLUE];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [self regularFontWithFontSize:22],NSFontAttributeName,
      [UIColor whiteColor], NSForegroundColorAttributeName,
      nil]];
    
    //Custom navigation bar back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [self regularFontWithFontSize:17],NSFontAttributeName,
                                                          Timetable_BLUE, NSForegroundColorAttributeName ,
                                                          nil] forState:UIControlStateNormal];
    //Custom tab bar
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setSelectedImageTintColor:Timetable_BLUE];
    [[UITabBar appearance] setBarTintColor:Timetable_SAND];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [self boldFontWithFontSize:12],NSFontAttributeName,
                                                          [UIColor blackColor], NSForegroundColorAttributeName ,
                                                          nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [self boldFontWithFontSize:12],NSFontAttributeName,
                                                       Timetable_BLUE, NSForegroundColorAttributeName ,
                                                       nil] forState:UIControlStateSelected];
}

#pragma mark Helper functions
- (UIFont *)regularFontWithFontSize:(CGFloat) size
{
    return [UIFont fontWithName:MS_REGULAR_FONT size:size];
}
- (UIFont *)boldFontWithFontSize:(CGFloat) size
{
    return [UIFont fontWithName:MS_BOLD_FONT size:size];
}
- (UIFont *)italicFontWithFontSize:(CGFloat) size
{
    return [UIFont fontWithName:MS_ITALIC_FONT size:size];
}


#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[AppSettings alloc] init];
}

- (id)mutableCopy
{
    return [[AppSettings alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
