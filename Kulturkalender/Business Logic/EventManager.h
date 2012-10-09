//
//  EventManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"
#import "Location.h"

@interface EventManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (id)sharedManager;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)reload;

@end

// Notifications

extern NSString * EventManagedDidRefresh;
// TODO: Add more 