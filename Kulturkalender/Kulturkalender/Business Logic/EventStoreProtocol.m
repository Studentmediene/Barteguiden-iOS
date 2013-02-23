//
//  EventStoreProtocol.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreProtocol.h"


// Errors
NSString * const EventStoreErrorDomain = @"EventStoreErrorDomain";

// Notifications
NSString * const EventStoreChangedNotification = @"EventStoreChangedNotification";

// User info keys
NSString * const EventStoreInsertedEventsKey = @"inserted";
NSString * const EventStoreUpdatedEventsKey = @"updated";
NSString * const EventStoreDeletedEventsKey = @"deleted";