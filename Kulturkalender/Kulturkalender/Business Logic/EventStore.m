//
//  EventStore.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventStore.h"

@interface EventStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation EventStore

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

// Accessing Events
- (id<RIOEvent>)eventWithIdentifier:(NSString *)identifier
{
    return nil;
}

- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate
{
    return nil;
}

- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    return nil;
}

- (NSPredicate *)predicateForFeaturedEvents
{
    return [NSPredicate predicateWithFormat:@"featured == 1"];
}

- (NSPredicate *)predicateForFavoritedEvents
{
    return [NSPredicate predicateWithFormat:@"favorite == 1"];
}

- (NSPredicate *)predicateForPaidEvents
{
    return [NSPredicate predicateWithFormat:@"price > 0"];;
}

- (NSPredicate *)predicateForFreeEvents
{
    return [NSPredicate predicateWithFormat:@"price == 0"];;
}

- (NSPredicate *)predicateForTitleContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", text];
}

- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"placeName CONTAINS[cd] %@", text];
}

// Saving and Removing Events
- (BOOL)saveEvent:(id<RIOEvent>)event error:(NSError *__autoreleasing *)error
{
    return NO;
}

- (BOOL)removeEvent:(id<RIOEvent>)event error:(NSError *__autoreleasing *)error
{
    return NO;
}

@end