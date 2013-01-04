//
//  EventStoreTests.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventStoreTests.h"
#import <CoreData/CoreData.h>
#import "EventKit.h"

@implementation EventStoreTests

- (void)setUp
{
    ManagedEventStore *eventStore = [[ManagedEventStore alloc] initWithManagedObjectContext:[self managedObjectContext]];
    
    // Import test data
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *events = values[@"events"];
    [eventStore importEvents:events];
    
    self.eventStore = eventStore;
}

- (void)tearDown
{
    
}


#pragma mark - Tests

- (void)testEventWithIdentifierReturnsNotNil
{
    NSString *identifier = @"1234-5678";
    id<Event> event = [self.eventStore eventWithIdentifier:identifier];
    STAssertNotNil(event, @"No event was returned.");
}

- (void)testPredicateForFeaturedEvents
{
    NSPredicate *predicate = [self.eventStore predicateForFeaturedEvents];
    NSArray *result = [self.eventStore eventsMatchingPredicate:predicate];
    STAssertEquals(result.count, 1U, @"Incorrect number of featured events.");
    // TODO: Check all returned IDs
}

// TODO: Check all predicates
// TODO: Create an extensive JSON test file

- (void)testLoadAllEvents
{
    NSArray *result = [self.eventStore eventsMatchingPredicate:nil];
    STAssertEquals(result.count, 4U, @"Incorrect number of events.");
}

// TODO: Move to EventTests? Rename?
- (void)testTitleOfEventIsValid
{
    NSString *identifier = @"1234-5678";
    id<Event> event = [self.eventStore eventWithIdentifier:identifier];
    STAssertEqualObjects(event.title, @"Tirsdagskviss", @"Incorrect title.");
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    // Managed object model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Kulturkalender" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Persistent store coordinator
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Managed object context
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return managedObjectContext;
}

@end
