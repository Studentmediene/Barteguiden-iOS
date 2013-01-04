//
//  RIOEventStore.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RIOEvent;

typedef void (^RIOEventSearchCallback)(id<RIOEvent> event, BOOL *stop);

@protocol RIOEventStore <NSObject>

// Access Events
- (id<RIOEvent>)eventWithIdentifier:(NSString *)identifier;
- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate;
- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(RIOEventSearchCallback)block;
- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSPredicate *)predicateForFeaturedEvents;
- (NSPredicate *)predicateForFavoritedEvents;
- (NSPredicate *)predicateForPaidEvents;
- (NSPredicate *)predicateForFreeEvents;
- (NSPredicate *)predicateForTitleContainingText:(NSString *)text;
- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text;
// TODO: Add predicates for categories, age limit and price

// Saving Changes
- (BOOL)save:(NSError **)error;

@end