//
//  CoreDataEventStore.h
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
@protocol NetworkActivity;

@class EventStoreCommunicator;
@class EventBuilder;


@interface CoreDataEventStore : NSObject <EventStore, EventStoreCommunicatorDelegate>

@property (nonatomic, strong) EventStoreCommunicator *communicator;
@property (nonatomic, strong) EventBuilder *builder;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (instancetype)init;
- (void)refresh;

@end