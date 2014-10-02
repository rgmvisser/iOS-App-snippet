//
//  MSNetworking.m
//  Timetable
//
//  Created by Ruud Visser on 04-08-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

static NSString * const TimetableURLString = @"https://www.name.com/1.0";

#import "MSNetworking.h"
#import "SearchableObject.h"
#import "Room.h"
#import "Timetable.h"
#import "TimeGridUnit.h"
#import "TimeGrid.h"
#import "NSDate+Extras.h"
#import "LocationType.h"
#import "Subject2.h"
#import "Location.h"
#import "Room2.h"
#import "GeneralAlert.h"
#import "RoomAlert.h"
#import "Notification.h"

@implementation MSNetworking

+ (MSNetworking *)sharedMSClient
{
    static MSNetworking *_sharedMSClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMSClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:TimetableURLString]];
    });
    
    return _sharedMSClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        //self.responseSerializer = [AFJSONResponseSerializer serializer];
        //self.requestSerializer = [AFJSONRequestSerializer serializer];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        self.token = [[AppSettings sharedInstance] getToken];
        DLog(@"Token: %@",self.token);
        
    }
    
    return self;
}

#pragma mark - Request manipulations
//add token to requests
- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?token=%@",self.token]];
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

-(AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?token=%@",self.token]];
    return [super GET:URLString parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?token=%@",self.token]];
    return [super DELETE:URLString parameters:parameters success:success failure:failure];
}

- (void)loadInformation{
    
    [self loadSearchableObjectsToCoreData];
    [self loadLocationTypesToCoreData];
    [self loadSubjectsToCoreData];
    [self loadLocationsToCoreData];
    [self loadRoomsToCoreData];
    [self loadAlertsToCoreData];
    
}

- (void)registerStudent:(NSString *)username withSuccess:(void (^)(void))success
{
    
    NSDictionary *parameters = @{
                                 @"username": username,
                                 @"has_accepted_terms" : [NSNumber numberWithBool:YES]
                                 };
    [self POST:@"register/student" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = [responseObject objectForKey:@"data"];
        NSString *token = [response objectForKey:@"token"];
        //on succes, store username/password in NSUserDefaults
        [[AppSettings sharedInstance] setLoginInformation:username password:token type:STUDENT];
        self.token = token;
        
        success();
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)registerTeacher:(NSString *)username withSuccess:(void (^)(void))success
{
    
    NSDictionary *parameters = @{
                                 @"username": username,
                                 @"has_accepted_terms" : [NSNumber numberWithBool:YES]
                                 };
    [self POST:@"register/teacher" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = [responseObject objectForKey:@"data"];
        NSString *token = [response objectForKey:@"token"];
        //on succes, store username/password in NSUserDefaults
        [[AppSettings sharedInstance] setLoginInformation:username password:token type:TEACHER];
        self.token = token;
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)registerEmployee:(NSString *)username withSuccess:(void (^)(void))success
{
    
    NSDictionary *parameters = @{
                                 @"username": username,
                                 @"has_accepted_terms" : [NSNumber numberWithBool:YES]
                                 };
    [self POST:@"register/employee" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = [responseObject objectForKey:@"data"];
        NSString *token = [response objectForKey:@"token"];
        //on succes, store username/password in NSUserDefaults
        [[AppSettings sharedInstance] setLoginInformation:username password:token type:EMPLOYEE];
        self.token = token;
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)loginWithSuccess:(void (^)(BOOL loggedIn))success
{
    [self GET:@"login" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *user = [[responseObject objectForKey:@"data"] objectForKey:@"user"];
        NSArray *subjectData = [[[responseObject objectForKey:@"data"] objectForKey:@"subscriptions"] objectForKey:@"subjects"];
        
        //userinfo
        NSNumber *userId = [user objectForKey:@"user_id"];
        NSNumber *studentId = [NSNumber numberWithInt:0];
        if([user objectForKey:@"student_id"] !=  [NSNull null]){
            studentId = [user objectForKey:@"student_id"];
        }
        
        NSNumber *teacherId = [NSNumber numberWithInt:0];
        if([user objectForKey:@"teacher_id"] != [NSNull null])
        {
            teacherId = [user objectForKey:@"teacher_id"];
        }
        NSString *email = [user objectForKey:@"email"];
        
        //subjects
        NSMutableArray *subjectSubscriptions = [[NSMutableArray alloc] init];
        for(NSDictionary *subject in subjectData){
            if([[subject objectForKey:@"subject_id"] intValue] < 100 && [[subject objectForKey:@"subject_id"] intValue] > 0)
            {
                [subjectSubscriptions addObject:[subject objectForKey:@"subject_id"]];
            }
        }
        [[AppSettings sharedInstance] setSubjectSubscriptions:subjectSubscriptions];
        
        [[AppSettings sharedInstance] storeAdditionalUserInformation:userId studentId:studentId teacherId:teacherId email:email];
        [[AppSettings sharedInstance] setIsStillLoggedIn:YES];
        [self loadInformation];
        
        [[AppSettings sharedInstance] askForNotifications];
        
        success(YES);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

        success(NO);
    }];
}



- (void)loadSearchableObjectsToCoreData
{
    [self GET:@"objects" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SearchableObject deleteAllObjects];
        NSArray *searchableObjects = [responseObject objectForKey:@"data"];
        //DLog(@"AFNetworking >> Objects downloaded: %lu",(unsigned long)[searchableObjects count]);
        //DLog(@"Obejcts: %@",searchableObjects);
        
        for (NSDictionary *searchableObject in searchableObjects) {
            //storing objects in coredata
            SearchableObject *newSearchableObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"SearchableObject"
                                          inManagedObjectContext:self.managedObjectContext];
            newSearchableObject.name = [searchableObject objectForKey:@"name"];
            newSearchableObject.objectId = [searchableObject objectForKey:@"object_id"];
            newSearchableObject.objectDescription = [searchableObject objectForKey:@"description"];
            newSearchableObject.isSearchable = [searchableObject objectForKey:@"is_searchable"];
            
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        DLog(@"Operation: %@", operation);
    }];
}

- (void)loadLocationsToCoreData
{
    [self GET:@"lookup/location" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Location deleteAllObjects];
        NSArray *locations = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
        //DLog(@"AFNetworking >> locationtypes downloaded: %lu",(unsigned long)[locations count]);
        
        int idCounter = 1;
        for (NSDictionary *locationData in locations) {
            //storing objects in coredata
            Location *location = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Location"
                                          inManagedObjectContext:self.managedObjectContext];
            location.locationId = [NSNumber numberWithInt:idCounter];
            location.key = [locationData objectForKey:@"key"];
            location.value = [locationData objectForKey:@"value"];
            location.depth = [NSNumber numberWithInt:[[locationData objectForKey:@"depth"] intValue]];
            location.isSelectable = [locationData objectForKey:@"is_selectable"];
            idCounter++;
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

- (void)loadLocationTypesToCoreData
{
    [self GET:@"lookup/location_type" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [LocationType deleteAllObjects];
        NSArray *locationTypes = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
        //DLog(@"AFNetworking >> locationtypes downloaded: %lu",(unsigned long)[locationTypes count]);
        //DLog(@"Obejcts: %@",searchableObjects);
        
        for (NSDictionary *locationTypeData in locationTypes) {
            //storing objects in coredata
            LocationType *locationType = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"LocationType"
                                          inManagedObjectContext:self.managedObjectContext];
            locationType.key = [locationTypeData objectForKey:@"key"];
            locationType.value = [locationTypeData objectForKey:@"value"];
            locationType.is_selectable = [locationTypeData objectForKey:@"is_selectable"];
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

- (void)loadAlertsToCoreData
{
    [self GET:@"lookup/alert_preset_general" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [GeneralAlert deleteAllObjects];
        NSArray *alerts = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
        
        for (NSDictionary *alertData in alerts) {
            //storing objects in coredata
            GeneralAlert *alert = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"GeneralAlert"
                                          inManagedObjectContext:self.managedObjectContext];
            alert.alertId = [[[NSNumberFormatter alloc] init] numberFromString:[alertData objectForKey:@"key"]];
            alert.name = [alertData objectForKey:@"value"];
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
    [self GET:@"lookup/alert_preset_room" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [RoomAlert deleteAllObjects];
        NSArray *alerts = [[responseObject objectForKey:@"data"] objectForKey:@"items"];
        
        for (NSDictionary *alertData in alerts) {
            //storing objects in coredata
            Alert *alert = [NSEntityDescription
                            insertNewObjectForEntityForName:@"RoomAlert"
                            inManagedObjectContext:self.managedObjectContext];
            alert.alertId = [[[NSNumberFormatter alloc] init] numberFromString:[alertData objectForKey:@"key"]];
            alert.name = [alertData objectForKey:@"value"];
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
}

- (void)loadRoomsToCoreData
{
    [self GET:@"rooms" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Room2 deleteAllObjects];
        NSArray *rooms = [responseObject objectForKey:@"data"];
        //DLog(@"AFNetworking >> locationtypes downloaded: %lu",(unsigned long)[locationTypes count]);
        //DLog(@"Obejcts: %@",searchableObjects);
        
        for (NSDictionary *roomData in rooms) {
            //storing objects in coredata
            Room2 *room = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Room2"
                                          inManagedObjectContext:self.managedObjectContext];
            [room loadFromDictionary:roomData];
        }
        
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

- (void)loadSubjectsToCoreData{
    
    [self GET:@"subjects" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Subject2 deleteAllObjects];
        NSArray *subjectsData = [responseObject objectForKey:@"data"];
        //DLog(@"AFNetworking >> locationtypes downloaded: %lu",(unsigned long)[subjectsData count]);
        //DLog(@"Obejcts: %@",searchableObjects);
        
        for (NSDictionary *subjectData in subjectsData) {
            //storing objects in coredata
            Subject2 *subject = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Subject2"
                                 inManagedObjectContext:self.managedObjectContext];
            subject.subjectId = [subjectData objectForKey:@"subject_id"];
            subject.subjectdescription = [subjectData objectForKey:@"description"];
            subject.name = [subjectData objectForKey:@"name"];
            subject.active = [subjectData objectForKey:@"active"];
        }
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}


- (void)getRooms:(NSNumber *)available onDate:(NSDate *)date withObjects:(NSArray *)objects withSuccess:(void (^)(NSArray *))success{
    
    NSDictionary *parameters = @{
                                 @"time_start": [date dateByAddingTimeInterval:(3600*2)], //need to add 2 hours, do not know why @TODO
                                 @"check_availablity" : available,
                                 @"objects" : objects
                                 };
    [self POST:@"rooms/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //DLog(@"Operation paras:%@",parameters);
        //DLog(@"JSON: %@", responseObject);
        NSMutableArray *timegrid = [[NSMutableArray alloc] init];
        for(NSDictionary *obj in [responseObject objectForKey:@"data"])
        {
            TimeGridUnit *tgu = [[TimeGridUnit alloc] init];
            [tgu loadRoomsFromDictionary:obj];
            [timegrid addObject:tgu];
        }

        success(timegrid);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Errorr: %@", error);
    }];
    
}

-(void)getTimeTableFrom:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSArray *timegrids))success{

    NSString *timetableURL = @"";
    if([[AppSettings sharedInstance] isStudent]){
        timetableURL = @"timetables/student";
    }
    else{
        timetableURL = @"timetables/teacher";
    }

    timetableURL = [timetableURL stringByAppendingString:@"/0"]; // 0 is own student
    
    //add starttime and endtime
    timetableURL = [timetableURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[from yyyymmddFormat]]];
    timetableURL = [timetableURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[to yyyymmddFormat]]];
    //DLog(@"Url: %@",timetableURL);
    
    [self GET:timetableURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        
        //NSLog(@"JSON: %@", responseObject);
        NSMutableArray *timeGrids = [[NSMutableArray alloc] init];
        for(NSDictionary *timeGridData in [data objectForKey:@"timegrids"])
        {
            TimeGrid *tg = [[TimeGrid alloc] init];
            [tg loadFromDictionary:timeGridData];
            [timeGrids addObject:tg];
            
        }
        success(timeGrids);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)getRoomTimeTable:(NSNumber *)roomId From:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSArray *))success
{
    NSString *timetableURL = [NSString stringWithFormat:@"timetables/room/%@",roomId];
    
    //add starttime and endtime
    timetableURL = [timetableURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[from yyyymmddFormat]]];
    timetableURL = [timetableURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[to yyyymmddFormat]]];
    
    [self GET:timetableURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        
        //NSLog(@"JSON: %@", responseObject);
        NSMutableArray *timeGrids = [[NSMutableArray alloc] init];
        for(NSDictionary *timeGridData in [data objectForKey:@"timegrids"])
        {
            TimeGrid *tg = [[TimeGrid alloc] init];
            [tg loadFromDictionary:timeGridData];
            [timeGrids addObject:tg];
            
        }
        success(timeGrids);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        success([[NSArray alloc] init]);
    }];
    
}


- (void)getBookingsWithSuccess:(void (^)(NSArray *))success
{
    NSString *bookingURL = @"";
    if([[AppSettings sharedInstance] isStudent]){
        bookingURL = @"reservations/student";
    }
    else{
        bookingURL = @"reservations/teacher";
    }
    
    bookingURL = [bookingURL stringByAppendingString:@"/0"]; // 0 is own student
    
    /*
    --if only from certain date --
     
    NSDate * from = [[NSDate alloc] init];
    //add starttime and endtime
    bookingURL = [bookingURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[from yyyymmddFormat]]];
    DLog(@"Url: %@",bookingURL);*/
    
    [self GET:bookingURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSMutableArray *timeGrids = [[NSMutableArray alloc] init];
        for(NSDictionary *timeGridData in [data objectForKey:@"timegrids"])
        {
            TimeGrid *tg = [[TimeGrid alloc] init];
            [tg loadFromDictionary:timeGridData];
            [timeGrids addObject:tg];
            
        }
        success(timeGrids);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)makeBookingForRooms:(NSArray *)rooms from:(NSDate *)from to:(NSDate *)to withSuccess:(void (^)(NSNumber *booked))success
{
    NSDictionary *parameters = @{
                                 @"rooms": rooms, //need to add 2 hours, do not know why @TODO
                                 @"time_start" : from,
                                 @"time_end" : to
                                 };
    DLog(@"Paras: %@",parameters);
    [self POST:@"timetables" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        NSNumber *booked = [responseObject objectForKey:@"success"];
        
        success(booked);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}

- (void)deleteBooking:(NSNumber *)timetableId withSuccess:(void (^)(void))success{
    
    NSString *URL = [NSString stringWithFormat:@"timetables/%@",timetableId];
    [self DELETE:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        if(![[responseObject objectForKey:@"success"] boolValue])
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:[responseObject objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else{
            success();
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Fout bij annuleren booking" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
}


- (void)registerForSubject:(NSNumber *)subjectId withSuccess:(void (^)(void))success{
    
    NSString *url = [NSString stringWithFormat:@"subjects/subscribe/%@",subjectId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        //NSNumber *subscribed = [responseObject objectForKey:@"success"];
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)deRegisterForSubject:(NSNumber *)subjectId withSuccess:(void (^)(void))success{
    
    NSString *url = [NSString stringWithFormat:@"subjects/subscribe/%@",subjectId];
    [self DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        //NSNumber *subscribed = [responseObject objectForKey:@"success"];
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)registerNotificationTokenForUser:(NSString *)token withSuccess:(void (^)(void))success{
    
    NSDictionary *parameters = @{
                                 @"device_token": token
                                 };
    [self POST:@"ios_device_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"Token: %@ sent",token);
        NSLog(@"JSON: %@", responseObject);
        //NSNumber *subscribed = [responseObject objectForKey:@"success"];
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)alert:(NSNumber *)alertId withMessage:(NSString *)message withSuccess:(void (^)(void))success
{
    NSDictionary *parameters = @{
                                 @"alert_preset_id": alertId,
                                 @"comment": message
                                 };
    [self POST:@"alerts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"Oper: %@",operation);
        NSLog(@"JSON: %@", responseObject);
        NSNumber *done = [responseObject objectForKey:@"success"];
        if ([done boolValue]) {
            success();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)getNotificationswithSuccess:(void (^)(NSArray *))success{
    
    [self GET:@"notifications" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Notification deleteAllObjects];
        NSArray *notificationsData = [responseObject objectForKey:@"data"];
        //DLog(@"AFNetworking >> locationtypes downloaded: %lu",(unsigned long)[subjectsData count]);
        
        
        NSMutableArray *notifications = [[NSMutableArray alloc] init];
        for (NSDictionary *notificationData in notificationsData) {
            //storing objects in coredata
            Notification *notification = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Notification"
                                 inManagedObjectContext:self.managedObjectContext];
            [notification loadFromDictionary:notificationData];
            [notifications addObject:notification];
            
        }
        success(notifications);
        [self saveCoreData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
}


- (void) saveCoreData
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else{
        //DLog(@"CoreData >> Saved to CoreData succesfully.");
    }
}



@end
