//
//  EventManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

static EventManager *_sharedManager;

+ (id)sharedManager
{
    return _sharedManager;
}

// TODO: Add parameter for connection?
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        _sharedManager = self;
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)refresh
{
    // TODO: Asynchronous download of content
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EventManagerDidRefreshNotification object:self];
}

@end


#pragma mark - Notifications

NSString *EventManagerDidRefreshNotification = @"EventManagerDidRefreshNotification";