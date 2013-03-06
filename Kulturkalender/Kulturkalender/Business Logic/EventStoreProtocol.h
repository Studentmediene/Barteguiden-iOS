//
//  EventStoreProtocol.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Event;

//typedef void (^EventSearchCallback)(id<Event> event, BOOL *stop);


@protocol EventStore <NSObject>

// Access Events
- (id<Event>)eventWithIdentifier:(NSString *)identifier error:(NSError **)error;
- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate error:(NSError **)error;
//- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(EventSearchCallback)block;

// Predicates
- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSPredicate *)predicateForFeaturedEvents;
- (NSPredicate *)predicateForFavoritedEvents;
- (NSPredicate *)predicateForPaidEvents;
- (NSPredicate *)predicateForFreeEvents;
- (NSPredicate *)predicateForEventsWithCategoryIDs:(NSArray *)categoryIDs;
- (NSPredicate *)predicateForEventsAllowedForAge:(NSUInteger)age;
- (NSPredicate *)predicateForTitleContainingText:(NSString *)text;
- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text;

// Saving Changes
- (BOOL)save:(NSError **)error;

@end

// Errors
extern NSString * const EventStoreErrorDomain;

typedef NS_ENUM(NSInteger, EventStoreErrorCode) {
    EventStoreFetchRequestFailed = 0,
    EventStoreSaveFailed = 1
};

// Notifications
extern NSString * const EventStoreChangedNotification;

// User info keys
extern NSString * const EventStoreInsertedEventsUserInfoKey;
extern NSString * const EventStoreUpdatedEventsUserInfoKey;
extern NSString * const EventStoreDeletedEventsUserInfoKey;