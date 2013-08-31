//
//  EventStore.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStore.h"


// Errors
NSString * const EventStoreErrorDomain = @"EventStoreErrorDomain";

// Notifications
NSString * const EventStoreWillDownloadDataNotification = @"EventStoreWillDownloadDataNotification";
NSString * const EventStoreDidDownloadDataNotification = @"EventStoreDidDownloadDataNotification";
NSString * const EventStoreDidRefreshNotification = @"EventStoreDidRefreshNotification";
NSString * const EventStoreChangedNotification = @"EventStoreChangedNotification";
NSString * const EventStoreDidFailNotification = @"EventStoreDidFailNotification";

// User info keys
NSString * const EventStoreInsertedEventsUserInfoKey = @"inserted";
NSString * const EventStoreUpdatedEventsUserInfoKey = @"updated";
NSString * const EventStoreDeletedEventsUserInfoKey = @"deleted";
NSString * const EventStoreErrorUserInfoKey = @"error";