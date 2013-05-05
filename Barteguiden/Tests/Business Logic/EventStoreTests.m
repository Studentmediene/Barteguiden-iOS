//
//  EventStoreTests.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

// TODO: Fix imports
// Class under test
#import "CoreDataEventStore.h"

// Collaborators
#import "Event.h"
#import "EventStoreCommunicatorMock.h"
#import "EventBuilder.h" // TODO: Create mock instead?

// Test support
#import <SenTestingKit/SenTestingKit.h>


@interface EventStoreTests : SenTestCase
@end

@implementation EventStoreTests {
    CoreDataEventStore *_eventStore;
}

- (void)setUp
{
    [self setUpEventStore];
}

- (void)tearDown
{
}


#pragma mark - Tests

// TODO: Remove comments
- (void)testEventWithIdentifierReturnsNotNil
{
    NSString *identifier = @"1";
    id<Event> event = [_eventStore eventWithIdentifier:identifier error:NULL];
    STAssertNotNil(event, @"No event was returned.");
}

- (void)testPredicateForFeaturedEventsShouldOnlyMatchFeaturedEvents
{
    NSPredicate *predicate = [_eventStore predicateForFeaturedEvents];
    NSArray *result = [_eventStore eventsMatchingPredicate:predicate error:NULL];
    STAssertEquals(result.count, 1U, @"Incorrect number of featured events.");
    
    // TODO: Check all returned IDs
//    [_eventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(id<Event> event, BOOL *stop) {
//    }];
}

// TODO: Check all predicates
// TODO: Create an extensive JSON test file

- (void)testNilPredicateShouldMatchAllEvents
{
    NSArray *result = [_eventStore eventsMatchingPredicate:nil error:NULL];
    STAssertEquals(result.count, 5U, @"Incorrect number of events.");
}

// TODO: Move to EventTests? Rename?
- (void)testTitleOfEventIsValid
{
    NSString *identifier = @"1";
    id<Event> event = [_eventStore eventWithIdentifier:identifier error:NULL];
    STAssertEqualObjects(event.title, @"Tirsdagsquiz", @"Incorrect title.");
}


#pragma mark - Private methods

- (void)setUpEventStore
{
    _eventStore = [[CoreDataEventStore alloc] initWithManagedObjectContext:[self managedObjectContext]];
    EventStoreCommunicator *communicator = [[EventStoreCommunicatorMock alloc] init];
    communicator.delegate = _eventStore;
    _eventStore.communicator = communicator;
    _eventStore.builder = [[EventBuilder alloc] init];
    [_eventStore refresh];
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Managed object model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EventKit" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Persistent store coordinator
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if ([persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error] == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Managed object context
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return managedObjectContext;
}

@end
