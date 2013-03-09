//
//  EventStore.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventStore.h"
#import <CoreData/CoreData.h>
#import "Event.h"
#import "EventStoreCommunicator.h"
#import "EventBuilder.h"
#import "NSError+RIOUnderlyingError.h"


static NSString * const kEventEntityName = @"Event";

static NSString * const kEventIDKey = @"eventID";
static NSString * const kTitleKey = @"title";
static NSString * const kStartAtKey = @"startAt";
static NSString * const kEndAtKey = @"endAt";

static NSString * const kFeaturedKey = @"featuredState";
static NSString * const kFavoriteKey = @"favoriteState";

static NSString * const kCategoryIDKey = @"categoryID";
static NSString * const kPriceKey = @"price";
static NSString * const kAgeLimitKey = @"ageLimitNumber";

static NSString * const kPlaceNameKey = @"placeName";
static NSString * const kAddressKey = @"address";
static NSString * const kLatitudeKey = @"latitude";
static NSString * const kLongitudeKey = @"longitude";

static NSString * const kURLKey = @"eventURL";

static NSString * const kCalendarEventIDKey = @"calendarEventID";


@interface EventStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation EventStore

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
        _communicator = [[EventStoreCommunicator alloc] init];
        _communicator.delegate = self;
        _builder = [[EventBuilder alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}

- (void)refresh
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreWillRefreshNotification object:self];
    
    [self.communicator downloadEventChanges];
}


#pragma mark - EventStoreCommunicatorDelegate

- (void)communicator:(EventStoreCommunicator *)communicator didReceiveEvents:(NSArray *)events
{
    NSMutableSet *eventIDs = [NSMutableSet set];
    
    for (NSDictionary *jsonObject in events) {
        NSString *eventID = jsonObject[kEventIDKey];
        [eventIDs addObject:eventID];
        
        Event *event = (Event *)[self eventWithIdentifier:eventID error:NULL]; // TODO: Fix error handling
        
        if (event != nil) {
            [self.builder updateEvent:event withJSONObject:jsonObject];
        }
        else {
            [self.builder insertNewEventWithJSONObject:jsonObject inManagedObjectContext:self.managedObjectContext];
        }
    }
    
    // TODO: Do not delete favorited events
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (%K IN %@)", kEventIDKey, eventIDs];
    NSArray *deletedEvents = [self eventsMatchingPredicate:predicate error:NULL]; // TODO: Fix error handling
    
    for (Event *deletedEvent in deletedEvents) {
        [self.managedObjectContext deleteObject:deletedEvent];
    }
}

- (void)communicator:(EventStoreCommunicator *)communicator didFailWithError:(NSError *)error
{
    // TODO: Fix
//    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreDidFailToRefreshNotification object:self userInfo:@{EventStoreRefreshErrorKey: error}];
}


#pragma mark - Notifications

- (void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)note
{
    NSSet *inserted = note.userInfo[NSInsertedObjectsKey];
    NSSet *updated = note.userInfo[NSUpdatedObjectsKey];
    NSSet *deleted = note.userInfo[NSDeletedObjectsKey];
    
    [self notifyEventStoreChangedWithInserted:inserted updated:updated deleted:deleted];
}


#pragma mark - Accessing Events

- (id<Event>)eventWithIdentifier:(NSString *)identifier error:(NSError **)error
{
    // Set up fetch request
    NSPredicate *predicate = [self predicateForEventIdentifier:identifier];
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    fetchRequest.fetchLimit = 1;
    
    // Fetch events and forward any errors
    NSArray *events = [self executeFetchRequest:fetchRequest error:error];
    if (events == nil) {
        return nil;
    }
    
    [self setDelegateOnEvents:events];
    
    // Retrieve single event
    if ([events count] > 0) {
        return events[0];
    }
    
    return nil;
}

- (NSArray *)eventsMatchingPredicate:(NSPredicate *)predicate error:(NSError **)error
{
    // Set up fetch request
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    // Fetch events and forward any errors
    NSArray *events = [self executeFetchRequest:fetchRequest error:error];
    if (events == nil) {
        return nil;
    }
    
    [self setDelegateOnEvents:events];
    
    return events;
}

// TODO: Implement
//- (void)enumerateEventsMatchingPredicate:(NSPredicate *)predicate usingBlock:(EventSearchCallback)block
//{
//}


#pragma mark - Predicates

- (NSPredicate *)predicateForEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    // TIPS: @"(endAt != nil AND endAt >= %@) OR startAt >= %@"
    return nil;
}

- (NSPredicate *)predicateForFeaturedEvents
{
    return [NSPredicate predicateWithFormat:@"%K == 1", kFeaturedKey];
}

- (NSPredicate *)predicateForFavoritedEvents
{
    return [NSPredicate predicateWithFormat:@"%K == 1", kFavoriteKey];
}

- (NSPredicate *)predicateForPaidEvents
{
    return [NSPredicate predicateWithFormat:@"%K > 0", kPriceKey];
}

- (NSPredicate *)predicateForFreeEvents
{
    return [NSPredicate predicateWithFormat:@"%K == 0", kPriceKey];
}

- (NSPredicate *)predicateForEventsWithCategoryIDs:(NSArray *)categoryIDs
{
    // TODO: Not tested
    return [NSPredicate predicateWithFormat:@"$K IN %@", kCategoryIDKey, categoryIDs];
}

- (NSPredicate *)predicateForEventsAllowedForAge:(NSUInteger)age
{
    // TODO: Not tested
    return [NSPredicate predicateWithFormat:@"%K <= %d", kAgeLimitKey, age];
}

- (NSPredicate *)predicateForTitleContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", kTitleKey, text];
}

- (NSPredicate *)predicateForPlaceNameContainingText:(NSString *)text
{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", kPlaceNameKey, text];
}


#pragma mark - Saving changes

- (BOOL)save:(NSError **)error
{
    NSError *underlyingError = nil;
    if ([self.managedObjectContext hasChanges] && [self.managedObjectContext save:&underlyingError] == NO) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:EventStoreErrorDomain code:EventStoreSaveFailed underlyingError:underlyingError];
        }
        
        return NO;
    }
    
    return YES;
}


#pragma mark - EventDelegate

- (void)eventDidChange:(Event *)event
{
//    NSLog(@"%@%@", NSStringFromSelector(_cmd), event);
    NSSet *updated = [NSSet setWithObject:event];
    [self notifyEventStoreChangedWithInserted:nil updated:updated deleted:nil];
}

- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size
{
    return [self.communicator URLForImageWithEventID:eventID size:size];
}


#pragma mark - Private methods

- (NSPredicate *)predicateForEventIdentifier:(NSString *)identifier
{
    return [NSPredicate predicateWithFormat:@"%K == %@", kEventIDKey, identifier];
}

- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEventEntityName];
    fetchRequest.includesSubentities = YES;
    fetchRequest.fetchBatchSize = 20; // TODO: Is it needed?
    fetchRequest.predicate = predicate;
    
    // Set sort descriptor
    NSSortDescriptor *startAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kStartAtKey ascending:YES];
    NSArray *sortDescriptors = @[startAtSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest error:(NSError **)error
{
    NSError *underlyingError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&underlyingError];
    if (result == nil && error != NULL) {
        *error = [NSError errorWithDomain:EventStoreErrorDomain code:EventStoreFetchRequestFailed underlyingError:underlyingError];
    }
    
    return result;
}

- (void)setDelegateOnEvents:(NSArray *)events
{
    __weak typeof(self) bself = self;
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = (Event *)obj;
        event.delegate = bself;
    }];
}

- (void)notifyEventStoreChangedWithInserted:(NSSet *)inserted updated:(NSSet *)updated deleted:(NSSet *)deleted
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [self addEvents:inserted toUserInfo:userInfo forKey:EventStoreInsertedEventsUserInfoKey];
    [self addEvents:updated toUserInfo:userInfo forKey:EventStoreUpdatedEventsUserInfoKey];
    [self addEvents:deleted toUserInfo:userInfo forKey:EventStoreDeletedEventsUserInfoKey];
    
    if (userInfo[EventStoreInsertedEventsUserInfoKey] == nil && userInfo[EventStoreUpdatedEventsUserInfoKey] == nil && userInfo[EventStoreDeletedEventsUserInfoKey] == nil) {
        return;
    }
    
    // NOTE: Make sure that delegate is set on new events
    [self setDelegateOnEvents:[userInfo[EventStoreInsertedEventsUserInfoKey] allObjects]];
    
//    NSLog(@"%@", userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreChangedNotification object:self userInfo:[userInfo copy]];
}

- (void)addEvents:(NSSet *)changes toUserInfo:(NSMutableDictionary *)userInfo forKey:(NSString *)key
{
    NSMutableSet *events = [NSMutableSet set];
    [changes enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[Event class]]) {
            [events addObject:obj];
        }
    }];
    
    if ([events count] > 0) {
        userInfo[key] = [events copy];
    }
}

@end