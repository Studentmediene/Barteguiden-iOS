//
//  AppDelegate.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 18.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventStore;
@class EventManager;// TODO: Temp
@class FilterManager;// TODO: Temp

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) EventStore *eventStore;
@property (nonatomic, strong) EventManager *eventManager;// TODO: Temp
@property (nonatomic, strong) FilterManager *filterManager;// TODO: Temp

- (void)save;
- (NSURL *)applicationDocumentsDirectory;

@end
