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
    // TODO: Asynchronous download of content
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example2" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"%@", values);
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+ZZ:ZZ"];
    
    NSArray *events = values[@"events"];
    for (NSDictionary *event in events) {
        // Event
        NSManagedObject *managedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
        [managedEvent safeSetValuesForKeysWithDictionary:event dateFormatter:nil];
        [managedEvent setValue:[NSDate date] forKey:@"timeStartAt"];
        [managedEvent setValue:[NSDate date] forKey:@"timeCreatedAt"];
        
        // Location
        NSManagedObject *managedLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        [managedLocation safeSetValuesForKeysWithDictionary:[event objectForKey:@"location"] dateFormatter:nil];
        [managedEvent setValue:managedLocation forKey:@"location"];
        
        // Localized description
        NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
        NSArray *descriptions = [event objectForKey:@"localizedDescription"];
        for (NSDictionary *description in descriptions) {
            NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:@"LocalizedDescription" inManagedObjectContext:self.managedObjectContext];
            [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:nil];
            [descriptionSet addObject:managedDescription];
        }
        [managedEvent setValue:descriptionSet forKey:@"localizedDescription"];
        
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

NSString *EventManagerDidRefreshNotification = @"EventManagerDidRefreshNotification";