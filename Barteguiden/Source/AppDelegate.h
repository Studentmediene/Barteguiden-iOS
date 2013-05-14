//
//  AppDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 18.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataEventStore;
@class UserDefaultsFilterManager;
@class UserDefaultsCalendarManager;
@class ApplicationNetworkActivity;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) CoreDataEventStore *eventStore;
@property (nonatomic, strong) UserDefaultsFilterManager *filterManager;
@property (nonatomic, strong) UserDefaultsCalendarManager *calendarManager;
@property (nonatomic, strong) ApplicationNetworkActivity *networkActivity;

@end
