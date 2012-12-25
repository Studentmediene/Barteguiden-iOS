//
//  EventManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventManager.h"
#import "ConnectionManager.h"

@implementation EventManager

@synthesize managedObjectContext=_managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext connectionManager:(id<ConnectionManager>)connectionManager
{
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)refresh
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EventManagerWillRefreshNotification object:self];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropbox.com/u/10851469/Under%20Dusken/Kulturkalender/Data.json"];
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:URL];
    
    typeof(self) bself = self;
    [NSURLConnection sendAsynchronousRequest:URLRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSLog(@"%@", data);
//        NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@", values);
        NSLog(@"%@", response);
       
        [bself refreshWithData:data];

//    //http://stackoverflow.com/questions/9270447/how-to-use-sendasynchronousrequestqueuecompletionhandler
//    if ([data length] > 0 && error == nil)
//        [delegate receivedData:data];
//    else if ([data length] == 0 && error == nil)
//        [delegate emptyReply];
//    else if (error != nil && error.code == ERROR_CODE_TIMEOUT)
//        [delegate timedOut];
//    else if (error != nil)
//        [delegate downloadError:error];
    }];
}
- (void)refreshWithData:(NSData *)data
{
    // TODO: Asynchronous download of content
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
    data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"%@", values);
    
    NSArray *events = values[@"events"];
    for (NSDictionary *event in events) {
        [Event insertNewEventWithJSONObject:event inManagedObjectContext:self.managedObjectContext];
    }
//    [self save];
    
//    NSLog(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:EventManagerDidRefreshNotification object:self];
}

- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end


#pragma mark - Notifications

NSString * const EventManagerWillRefreshNotification = @"EventManagerWillRefreshNotification";
NSString * const EventManagerDidRefreshNotification = @"EventManagerDidRefreshNotification";