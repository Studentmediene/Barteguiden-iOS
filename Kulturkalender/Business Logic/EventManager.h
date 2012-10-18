//
//  EventManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"
#import "Event+Custom.h"
#import "Location.h"
#import "LocalizedDescription.h"
#import "LocalizedFeatured.h"

@interface EventManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (id)sharedManager;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)refresh;

@end

// Notifications
extern NSString * const EventManagerWillRefreshNotification;
extern NSString * const EventManagerDidRefreshNotification;