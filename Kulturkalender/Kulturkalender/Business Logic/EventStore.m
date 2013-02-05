//
//  EventStore.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventStore.h"
#import "Event+Mapping.h"


static NSString * const kEventEntityName = @"Event";


@implementation EventStore {
    NSManagedObjectContext *_managedObjectContext;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)importEvents:(NSArray *)events
{
    for (NSDictionary *event in events) {
        [Event insertNewEventWithJSONObject:event inManagedObjectContext:_managedObjectContext];
    }
}


#pragma mark - Accessing Events

- (id<Event>)eventWithIdentifier:(NSString *)identifier
{
    NSPredicate *predicate = [self predicateForEventIdentifier:identifier];
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    fetchRequest.fetchLimit = 1;
    
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:nil]; // TODO: Fix error handling
    if (result.count > 0) {
        return result[0];
    }
    
    return nil;
}

- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:nil]; // TODO: Fix error handling
    return result;
}

- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(EventSearchCallback)block
{
    
}


#pragma mark - Predicates

- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    // TIPS: @"(endAt != nil AND endAt >= %@) OR startAt >= %@"
    return nil;
}

- (NSPredicate *)predicateForFeaturedEvents
{
    return [NSPredicate predicateWithFormat:@"featuredState == 1"];
}

- (NSPredicate *)predicateForFavoritedEvents
{
    return [NSPredicate predicateWithFormat:@"favoriteState == 1"];
}

- (NSPredicate *)predicateForPaidEvents
{
    return [NSPredicate predicateWithFormat:@"price > 0"];
}

- (NSPredicate *)predicateForFreeEvents
{
    return [NSPredicate predicateWithFormat:@"price == 0"];
}

- (NSPredicate *)predicateForEventsWithCategoryIDs:(NSArray *)categoryIDs
{
    // TODO: Not tested
    return [NSPredicate predicateWithFormat:@"categoryID IN %@", categoryIDs];
}

- (NSPredicate *)predicateForEventsAllowedForAge:(NSUInteger)age
{
    // TODO: Not tested
    return [NSPredicate predicateWithFormat:@"ageLimit <= %d", age];
}

- (NSPredicate *)predicateForTitleContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", text];
}

- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"placeName CONTAINS[cd] %@", text];
}


#pragma mark - Saving changes

- (BOOL)save:(NSError *__autoreleasing *)error
{
    return ([_managedObjectContext hasChanges] && ![_managedObjectContext save:error]);
}


#pragma mark - Private methods

- (NSPredicate *)predicateForEventIdentifier:(NSString *)identifier
{
    return [NSPredicate predicateWithFormat:@"eventID == %@", identifier];
}

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEventEntityName];
    fetchRequest.includesSubentities = YES;
    fetchRequest.fetchBatchSize = 20;
    fetchRequest.predicate = predicate;
    
    // TODO: Do I need sort descriptors?
//    NSSortDescriptor *startAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startAt" ascending:YES];
//    NSArray *sortDescriptors = @[ startAtSortDescriptor ];
//    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

@end