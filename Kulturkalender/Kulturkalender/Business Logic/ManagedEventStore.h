//
//  ManagedEventStore.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIOEventStore.h"


@interface ManagedEventStore : NSObject <RIOEventStore>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)importEvents:(NSArray *)events;

@end
