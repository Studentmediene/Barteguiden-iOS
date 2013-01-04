//
//  ManagedEventStore.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "ManagedEventStore.h"
#import "Event+Mapping.h"

@interface ManagedEventStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

static NSString * const kEventEntityName = @"Event";


@implementation ManagedEventStore

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
        [ManagedEvent insertNewEventWithJSONObject:event inManagedObjectContext:self.managedObjectContext];
    }
}


#pragma mark - Accessing Events

- (id<Event>)eventWithIdentifier:(NSString *)identifier
{
    NSPredicate *predicate = [self predicateForEventIdentifier:identifier];
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    fetchRequest.fetchLimit = 1;
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil]; // TODO: Fix error handling
    if (result.count > 0) {
        return result[0];
    }
    
    return nil;
}

- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil]; // TODO: Fix error handling
    return result;
}

- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(RIOEventSearchCallback)block
{
    
}

- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    // TIPS: @"(endAt != nil AND endAt >= %@) OR startAt >= %@"
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
    return [NSPredicate predicateWithFormat:@"price > 0"];
}

- (NSPredicate *)predicateForFreeEvents
{
    return [NSPredicate predicateWithFormat:@"price == 0"];
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
    return ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:error]);
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