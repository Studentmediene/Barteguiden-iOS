//
//  EventBuilderTests.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 19.08.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

// Class under test
#import "EventBuilder.h"

// Collaborators
#import "Event.h"

// Test support
#import <SenTestingKit/SenTestingKit.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


#define RIOSaveMOCWithoutErrors() \
do { \
    NSError *error; \
    BOOL saved = [_managedObjectContext save:&error]; \
    STAssertEquals(saved, YES, nil); \
    STAssertNil(error, nil); \
} while (0);


@interface EventBuilderTests : SenTestCase
@end


@implementation EventBuilderTests {
    EventBuilder *_eventBuilder;
    NSManagedObjectContext *_managedObjectContext;
    
}

- (void)setUp
{
    _eventBuilder = [[EventBuilder alloc] init];
    _managedObjectContext = [self managedObjectContext];
}

- (void)tearDown
{
}


#pragma mark - Insertion tests

- (void)testInsertEventShouldReturnNilWhenJsonObjectIsNil
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:nil inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNil(event, @"Event should be nil");
}

- (void)testInsertEventShouldReturnNilWhenJsonObjectIsEmptyDictionary
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:@{} inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNil(event, @"Event should be nil");
}

- (void)testInsertEventShouldReturnCorrectObjectWhenJsonObjectIsSimpleValidEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self simpleValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"37", nil);
    STAssertEqualObjects(event.title, @"Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921280], nil);
    STAssertEqualObjects(event.placeName, @"Trondheim", nil);
}

- (void)testInsertEventShouldReturnNilWhenJsonObjectIsMalformedSimpleEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self malformedSimpleEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNil(event, @"Event should be nil");
}

- (void)testInsertEventShouldReturnCorrectObjectWhenJsonObjectIsCompleteValidEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self completeValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"37", nil);
    STAssertEqualObjects(event.title, @"Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921280], nil);
    STAssertEqualObjects(event.placeName, @"Trondheim", nil);
    STAssertEqualObjects(event.address, @"Elgeseter gate 1", nil);
    STAssertEqualObjects(event.latitude, @63.5, nil);
    STAssertEqualObjects(event.longitude, @10.11, nil);
    STAssertEqualObjects(event.ageLimit, @18, nil);
    STAssertEqualObjects(event.price, @100, nil);
    STAssertEqualObjects(event.categoryID, @(EventCategoryMusic), nil);
    STAssertEqualObjects(event.description_nb, @"Text", nil);
    STAssertNil(event.description_en, nil);
    STAssertEquals(event.featured, NO, nil);
    STAssertEqualObjects(event.eventURL, @"http://event.com/1", nil);
    STAssertEqualObjects(event.imageURL, @"http://placehold.it/200x200", nil);
}

- (void)testInsertEventShouldReturnCorrectObjectWhenJsonObjectIsAnotherCompleteValidEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self anotherCompleteValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"38", nil);
    STAssertEqualObjects(event.title, @"Another Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921281], nil);
    STAssertEqualObjects(event.placeName, @"Oslo", nil);
    STAssertEqualObjects(event.address, @"Elgeseter gate 2", nil);
    STAssertEqualObjects(event.latitude, @63.6, nil);
    STAssertEqualObjects(event.longitude, @10.12, nil);
    STAssertEqualObjects(event.ageLimit, @19, nil);
    STAssertEqualObjects(event.price, @101, nil);
    STAssertEqualObjects(event.categoryID, @(EventCategorySport), nil);
    STAssertEqualObjects(event.description_nb, @"Text", nil);
    STAssertEqualObjects(event.description_en, @"Another text", nil);
    STAssertEquals(event.featured, YES, nil);
    STAssertEqualObjects(event.eventURL, @"http://event.com/2", nil);
    STAssertEqualObjects(event.imageURL, @"http://placehold.it/201x201", nil);
}

- (void)testInsertEventShouldReturnNilWhenJsonObjectIsMalformedCompleteEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self malformedCompleteEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNil(event, @"Event should be nil");
}


#pragma mark - Insert and update tests

- (void)testInsertAndUpdateEventShouldReturnCorrectObjectWhenJsonObjectIsSimpleValidEvent
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self simpleValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    [_eventBuilder updateEvent:event withJSONObject:[self anotherSimpleValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"38", nil);
    STAssertEqualObjects(event.title, @"Another Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921281], nil);
    STAssertEqualObjects(event.placeName, @"Oslo", nil);
}

- (void)testInsertAndUpdateEventShouldReturnCorrectObjectWhenJsonObjectIsCompleteValidEventAndUpdatedWithCompleteValidEventWithNullValues
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self anotherCompleteValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    [_eventBuilder updateEvent:event withJSONObject:[self completeValidEventWithNullValues] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"37", nil);
    STAssertEqualObjects(event.title, @"Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921280], nil);
    STAssertEqualObjects(event.placeName, @"Trondheim", nil);
    STAssertNil(event.address, nil);
    STAssertNil(event.latitude, nil);
    STAssertNil(event.longitude, nil);
    STAssertEqualObjects(event.ageLimit, @0, nil);
    STAssertEqualObjects(event.price, @0, nil);
    STAssertEqualObjects(event.categoryID, @(EventCategoryOther), nil);
    STAssertNil(event.description_nb, nil);
    STAssertNil(event.description_en, nil);
    STAssertEquals(event.featured, NO, nil);
    STAssertNil(event.eventURL, nil);
    STAssertNil(event.imageURL, nil);
}

- (void)testInsertAndUpdateEventShouldReturnCorrectObjectWhenJsonObjectIsCompleteValidEventAndUpdatedWithMalformedCompleteEventWithNullValues
{
    Event *event = [_eventBuilder insertNewEventWithJSONObject:[self completeValidEvent] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    [_eventBuilder updateEvent:event withJSONObject:[self malformedCompleteEventWithNullValues] inManagedObjectContext:_managedObjectContext];
    RIOSaveMOCWithoutErrors();
    
    STAssertNotNil(event, @"Event should not be nil");
    STAssertEqualObjects(event.eventID, @"37", nil);
    STAssertEqualObjects(event.title, @"Title", nil);
    STAssertEqualObjects(event.startAt, [NSDate dateWithTimeIntervalSince1970:1376921280], nil);
    STAssertEqualObjects(event.placeName, @"Trondheim", nil);
    STAssertEqualObjects(event.address, @"Elgeseter gate 1", nil);
    STAssertEqualObjects(event.latitude, @63.5, nil);
    STAssertEqualObjects(event.longitude, @10.11, nil);
    STAssertEqualObjects(event.ageLimit, @18, nil);
    STAssertEqualObjects(event.price, @100, nil);
    STAssertEqualObjects(event.categoryID, @(EventCategoryMusic), nil);
    STAssertEqualObjects(event.description_nb, @"Text", nil);
    STAssertNil(event.description_en, nil);
    STAssertEquals(event.featured, NO, nil);
    STAssertEqualObjects(event.eventURL, @"http://event.com/1", nil);
    STAssertEqualObjects(event.imageURL, @"http://placehold.it/200x200", nil);
}



#pragma mark - Private methods

- (NSDictionary *)simpleValidEvent
{
    return @{@"eventID": @"37",
             @"title": @"Title",
             @"startAt": @"2013-08-19T14:08:00.000Z",
             @"placeName": @"Trondheim"};
}

- (NSDictionary *)anotherSimpleValidEvent
{
    return @{@"eventID": @"38",
             @"title": @"Another Title",
             @"startAt": @"2013-08-19T14:08:01.000Z",
             @"placeName": @"Oslo"};
}

- (NSDictionary *)malformedSimpleEvent
{
    return @{@"eventID": @0,
             @"title": @0,
             @"startAt": @0,
             @"placeName": @0};
}

- (NSDictionary *)completeValidEvent
{
    NSDictionary *values = @{@"address": @"Elgeseter gate 1",
                             @"latitude": @63.5,
                             @"longitude": @10.11,
                             @"ageLimit": @18,
                             @"price": @100,
                             @"categoryID": @"MUSIC",
                             @"descriptions": @[
                                     @{@"language": @"nb",
                                       @"text": @"Text"}],
                             @"isRecommended": @NO,
                             @"eventURL": @"http://event.com/1",
                             @"imageURL": @"http://placehold.it/200x200"};
    
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    [event addEntriesFromDictionary:[self simpleValidEvent]];
    [event addEntriesFromDictionary:values];
    return event;
}

- (NSDictionary *)anotherCompleteValidEvent
{
    NSDictionary *values = @{@"address": @"Elgeseter gate 2",
                             @"latitude": @63.6,
                             @"longitude": @10.12,
                             @"ageLimit": @19,
                             @"price": @101,
                             @"categoryID": @"SPORT",
                             @"descriptions": @[
                                     @{@"language": @"nb",
                                       @"text": @"Text"},
                                     @{@"language": @"en",
                                       @"text": @"Another text"}],
                             @"isRecommended": @YES,
                             @"eventURL": @"http://event.com/2",
                             @"imageURL": @"http://placehold.it/201x201"};
    
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    [event addEntriesFromDictionary:[self anotherSimpleValidEvent]];
    [event addEntriesFromDictionary:values];
    return event;
}

- (NSDictionary *)malformedCompleteEvent
{
    NSDictionary *values = @{@"address": @0,
                             @"latitude": @"",
                             @"longitude": @"",
                             @"ageLimit": @"",
                             @"price": @"",
                             @"categoryID": @0,
                             @"descriptions": @[
                                     @{@"language": @0,
                                       @"text": @0}],
                             @"isRecommended": @"",
                             @"eventURL": @0,
                             @"imageURL": @0};
    
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    [event addEntriesFromDictionary:[self malformedSimpleEvent]];
    [event addEntriesFromDictionary:values];
    return event;
}

- (NSDictionary *)completeValidEventWithNullValues
{
    NSDictionary *values = @{@"address": [NSNull null],
                             @"latitude": [NSNull null],
                             @"longitude": [NSNull null],
                             @"ageLimit": [NSNull null],
                             @"price": [NSNull null],
                             @"categoryID": [NSNull null],
                             @"descriptions": [NSNull null],
                             @"isRecommended": [NSNull null],
                             @"eventURL": [NSNull null],
                             @"imageURL": [NSNull null]};
    
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    [event addEntriesFromDictionary:[self simpleValidEvent]];
    [event addEntriesFromDictionary:values];
    return event;
}

- (NSDictionary *)malformedCompleteEventWithNullValues
{
    return @{@"eventID": [NSNull null],
             @"title": [NSNull null],
             @"startAt": [NSNull null],
             @"placeName": [NSNull null],
             @"address": [NSNull null],
             @"latitude": [NSNull null],
             @"longitude": [NSNull null],
             @"ageLimit": [NSNull null],
             @"price": [NSNull null],
             @"categoryID": [NSNull null],
             @"descriptions": [NSNull null],
             @"isRecommended": [NSNull null],
             @"eventURL": [NSNull null],
             @"imageURL": [NSNull null]};
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
