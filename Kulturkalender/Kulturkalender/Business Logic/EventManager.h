//
//  EventManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedEvent.h"
#import "Event+Mapping.h"
#import "Event+TableView.h"
#import "Event+Time.h"
#import "Event+LocalizedText.h"
#import "Event+Category.h"
#import "Event+AgeLimit.h"
#import "Event+Price.h"
#import "Event+Location.h"
#import "LocalizedDescription.h"
#import "LocalizedFeatured.h"


@protocol EventManager <NSObject>

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)refresh;
- (void)save;

@end


@protocol ConnectionManager;

@interface EventManager : NSObject <EventManager>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

// Notifications
extern NSString * const EventManagerWillRefreshNotification;
extern NSString * const EventManagerDidRefreshNotification;