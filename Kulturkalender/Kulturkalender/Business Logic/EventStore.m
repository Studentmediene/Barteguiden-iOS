//
//  EventStore.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventStore.h"
#import "EventBuilder.h"


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
        [EventBuilder insertNewEventWithJSONObject:event inManagedObjectContext:_managedObjectContext];
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
    
    // Set sort descriptor
    NSSortDescriptor *startAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startAt" ascending:YES];
    NSArray *sortDescriptors = @[ startAtSortDescriptor ];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}


#pragma mark - TODO: From EventManager

//- (void)refresh
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:EventStoreWillRefreshNotification object:self];
//    
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
//
//- (void)save
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end