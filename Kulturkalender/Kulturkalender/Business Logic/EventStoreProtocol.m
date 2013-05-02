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
NSString * const EventStoreDidFailNotification = @"EventStoreDidFailNotification";

// User info keys
NSString * const EventStoreInsertedEventsUserInfoKey = @"EventStoreInsertedEventsUserInfoKey";
NSString * const EventStoreUpdatedEventsUserInfoKey = @"EventStoreUpdatedEventsUserInfoKey";
NSString * const EventStoreDeletedEventsUserInfoKey = @"EventStoreDeletedEventsUserInfoKey";
NSString * const EventStoreErrorUserInfoKey = @"EventStoreErrorUserInfoKey";