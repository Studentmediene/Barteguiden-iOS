//
//  EventStore.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventKit.h"
#import "EventDelegate.h"
#import "EventStoreCommunicatorDelegate.h"


@protocol EventStoreDelegate;

@class EventStoreCommunicator;
@class EventBuilder;

@interface CoreDataEventStore : NSObject <EventStore, EventDelegate, EventStoreCommunicatorDelegate>

@property (nonatomic, strong) EventStoreCommunicator *communicator;
@property (nonatomic, strong) EventBuilder *builder;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)refresh;

@end