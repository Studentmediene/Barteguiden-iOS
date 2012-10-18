//
//  EventManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventManager.h"
#import "NSManagedObject+CIMGF.h"

@implementation EventManager

static EventManager *_sharedManager;

+ (id)sharedManager
{
    return _sharedManager;
}

// TODO: Add parameter for connection?
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _sharedManager = self;
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)refresh
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EventManagerWillRefreshNotification object:self];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    NSURL *URL = [NSURL URLWithString:@"https://dl.dropbox.com/u/10851469/Temp/Example2.json"];
//    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:URL];
//    
//    typeof(self) bself = self;
//    [NSURLConnection sendAsynchronousRequest:URLRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
////        NSLog(@"%@", data);
////        NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////        NSLog(@"%@", values);
//        NSLog(@"%@", response);
//       
//        [bself refreshWithData:data];
//
//    //http://stackoverflow.com/questions/9270447/how-to-use-sendasynchronousrequestqueuecompletionhandler
//    if ([data length] > 0 && error == nil)
//        [delegate receivedData:data];
//    else if ([data length] == 0 && error == nil)
//        [delegate emptyReply];
//    else if (error != nil && error.code == ERROR_CODE_TIMEOUT)
//        [delegate timedOut];
//    else if (error != nil)
//        [delegate downloadError:error];
//    }];
//}
//- (void)refreshWithData:(NSData *)data
//{
    // TODO: Asynchronous download of content
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example2" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"%@", values);
    
    NSDateFormatter *iso8601dateFormatter = [[NSDateFormatter alloc] init];
    [iso8601dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSArray *events = values[@"events"];
    for (NSDictionary *event in events) {
        // Event
        NSManagedObject *managedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
        [managedEvent safeSetValuesForKeysWithDictionary:event dateFormatter:iso8601dateFormatter];
//        [managedEvent setValue:[NSDate date] forKey:@"timeStartAt"];
        [managedEvent setValue:[NSDate date] forKey:@"timeCreatedAt"];
        
        // Location
        NSManagedObject *managedLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        [managedLocation safeSetValuesForKeysWithDictionary:[event objectForKey:@"location"] dateFormatter:iso8601dateFormatter];
        [managedEvent setValue:managedLocation forKey:@"location"];
        
        // Localized description
        NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
        NSArray *descriptions = [event objectForKey:@"localizedDescription"];
        for (NSDictionary *description in descriptions) {
            NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:@"LocalizedDescription" inManagedObjectContext:self.managedObjectContext];
            [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:iso8601dateFormatter];
            [descriptionSet addObject:managedDescription];
        }
        [managedEvent setValue:descriptionSet forKey:@"localizedDescription"];
        
        // Localized featured
        NSMutableSet *featuredSet = [[NSMutableSet alloc] init];
        NSArray *featureds = [event objectForKey:@"localizedFeatured"];
        for (NSDictionary *featured in featureds) {
            NSManagedObject *managedFeatured = [NSEntityDescription insertNewObjectForEntityForName:@"LocalizedFeatured" inManagedObjectContext:self.managedObjectContext];
            [managedFeatured safeSetValuesForKeysWithDictionary:featured dateFormatter:iso8601dateFormatter];
            [featuredSet addObject:managedFeatured];
        }
        [managedEvent setValue:featuredSet forKey:@"localizedFeatured"];
    }
    [self saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EventManagerDidRefreshNotification object:self];
}


#pragma mark - Private methods

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end


#pragma mark - Notifications

NSString * const EventManagerWillRefreshNotification = @"EventManagerWillRefreshNotification";
NSString * const EventManagerDidRefreshNotification = @"EventManagerDidRefreshNotification";