//
//  EventStore.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventKit.h"
#import "EventDelegate.h"


@interface EventStore : NSObject <EventStore, EventDelegate>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)importEvents:(NSArray *)events;

- (NSURL *)URLForEventChanges;
- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size;

@end