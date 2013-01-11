//
//  EventStoreTests.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "EventStore.h"
#import "Event.h"


@interface EventStoreTests : SenTestCase
@end

@implementation EventStoreTests {
    id<EventStore> _eventStore;
}

- (void)setUp
{
    _eventStore = [self eventStore];
}

- (void)tearDown
{
}


#pragma mark - Tests

- (void)testEventWithIdentifierReturnsNotNil
{
    NSString *identifier = @"1234-5678";
    id<Event> event = [_eventStore eventWithIdentifier:identifier];
    STAssertNotNil(event, @"No event was returned.");
}

- (void)testPredicateForFeaturedEventsShouldOnlyMatchFeaturedEvents
{
    NSPredicate *predicate = [EventStore predicateForFeaturedEvents];
    NSArray *result = [_eventStore eventsMatchingPredicate:predicate];
    STAssertEquals(result.count, 1U, @"Incorrect number of featured events.");
    
    // TODO: Check all returned IDs
//    [_eventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(id<Event> event, BOOL *stop) {
//    }];
}

// TODO: Check all predicates
// TODO: Create an extensive JSON test file

- (void)testNilPredicateShouldMatchAllEvents
{
    NSArray *result = [_eventStore eventsMatchingPredicate:nil];
    STAssertEquals(result.count, 4U, @"Incorrect number of events.");
}

// TODO: Move to EventTests? Rename?
- (void)testTitleOfEventIsValid
{
    NSString *identifier = @"1234-5678";
    id<Event> event = [_eventStore eventWithIdentifier:identifier];
    STAssertEqualObjects(event.title, @"Tirsdagskviss", @"Incorrect title.");
}


#pragma mark - Private methods

- (EventStore *)eventStore
{
    EventStore *eventStore = [[EventStore alloc] initWithManagedObjectContext:[self managedObjectContext]];
    
    // Import test data
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *events = values[@"events"];
    [eventStore importEvents:events];
    
    return eventStore;
}

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
