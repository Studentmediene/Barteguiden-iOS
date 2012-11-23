//
//  EventManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"
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

@interface EventManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (id)sharedManager;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)refresh;
- (void)save;

@end

// Notifications
extern NSString * const EventManagerWillRefreshNotification;
extern NSString * const EventManagerDidRefreshNotification;