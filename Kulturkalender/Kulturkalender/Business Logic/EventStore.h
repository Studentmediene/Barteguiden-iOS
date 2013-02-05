//
//  EventStore.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventKit.h"

// Notifications
//extern NSString * const EventStoreChangedNotification;


@interface EventStore : NSObject <EventStore>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)importEvents:(NSArray *)events;

@end
