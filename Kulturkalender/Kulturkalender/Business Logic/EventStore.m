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
#import "EventBuilder.h"
#import "NSError+RIOUnderlyingError.h"


static NSString * const kEventEntityName = @"Event";


@interface EventStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation EventStore

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}

- (void)importEvents:(NSArray *)events
{
    for (NSDictionary *event in events) {
        [EventBuilder insertNewEventWithJSONObject:event inManagedObjectContext:self.managedObjectContext];
    }
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:@"http://kk.skohorn.net/"];
}

- (NSURL *)URLForEventChanges
{
    return [NSURL URLWithString:@"events/changes"];
//    return [NSURL URLWithString:@"events/changes" relativeToURL:[self baseURL]];
}

- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size
{
//    NSString *path = [NSString stringWithFormat:@"events/%@.png?size=%dx%d", eventID, (int)size.width, (int)size.height];
    NSString *path = [NSString stringWithFormat:@"img/%@.png", eventID];
    return [NSURL URLWithString:path relativeToURL:[self baseURL]];
}


#pragma mark - Notifications

- (void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)note
{
    [self notifyEventStoreChangedWithInserted:note.userInfo[NSInsertedObjectsKey] updated:note.userInfo[NSUpdatedObjectsKey] deleted:note.userInfo[NSDeletedObjectsKey]];
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
    NSLog(@"%@%@", NSStringFromSelector(_cmd), event);
    NSSet *updated = [NSSet setWithObject:event];
    [self notifyEventStoreChangedWithInserted:nil updated:updated deleted:nil];
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
    fetchRequest.fetchBatchSize = 20; // TODO: Is it needed?
    fetchRequest.predicate = predicate;
    
    // Set sort descriptor
    NSSortDescriptor *startAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startAt" ascending:YES];
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
    [self addEvents:inserted toUserInfo:userInfo forKey:EventStoreInsertedEventsKey];
    [self addEvents:updated toUserInfo:userInfo forKey:EventStoreUpdatedEventsKey];
    [self addEvents:deleted toUserInfo:userInfo forKey:EventStoreDeletedEventsKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreChangedNotification object:self userInfo:[userInfo copy]];
}

- (void)addEvents:(NSSet *)changes toUserInfo:(NSMutableDictionary *)userInfo forKey:(NSString *)key
{
    NSMutableSet *events = [NSMutableSet set];
    [changes enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[Event class]]) {
            [events addObject:obj];
        }
        
        // TODO: Should I add other entities as well?
    }];
    
    if ([events count] > 0) {
        userInfo[key] = [events copy];
    }
}

#pragma mark - TODO: From EventManager

//- (void)refresh
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreWillRefreshNotification object:self];
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    //    NSURL *url = [NSURL URLWithString:@"https://dl.dropbox.com/u/10851469/Under%20Dusken/Kulturkalender/Data.json"];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
//    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:url];
//    
//    typeof(self) bself = self;
//    [NSURLConnection sendAsynchronousRequest:URLRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        //        NSLog(@"%@", data);
//        //        NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        //        NSLog(@"%@", values);
//        NSLog(@"%@", response);
//        
//        [bself refreshWithData:data];
//        
//        //    //http://stackoverflow.com/questions/9270447/how-to-use-sendasynchronousrequestqueuecompletionhandler
//        //    if ([data length] > 0 && error == nil)
//        //        [delegate receivedData:data];
//        //    else if ([data length] == 0 && error == nil)
//        //        [delegate emptyReply];
//        //    else if (error != nil && error.code == ERROR_CODE_TIMEOUT)
//        //        [delegate timedOut];
//        //    else if (error != nil)
//        //        [delegate downloadError:error];
//    }];
//}
//- (void)refreshWithData:(NSData *)data
//{
//    // TODO: Asynchronous download of content
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
//    data = [NSData dataWithContentsOfURL:url];
//    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    //    NSLog(@"%@", values);
//    
//    NSArray *events = values[@"events"];
//    for (NSDictionary *event in events) {
//        [Event insertNewEventWithJSONObject:event inManagedObjectContext:self.managedObjectContext];
//    }
//    //    [self save];
//    
//    //    NSLog(@"");
//    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreDidRefreshNotification object:self];
//}

@end