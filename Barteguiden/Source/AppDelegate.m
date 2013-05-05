//
//  AppDelegate.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 18.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreData/CoreData.h>
#import "CoreDataEventStore.h"

#import "UserDefaultsFilterManager.h"

#import <EventKit/EventKit.h>
#import "UserDefaultsCalendarManager.h"

#import "TabBarController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpStyles];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Event store
    self.eventStore = [[CoreDataEventStore alloc] initWithManagedObjectContext:self.managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreDidFailNotification:) name:EventStoreDidFailNotification object:self.eventStore];
    
    // Filter manager
    self.filterManager = [[UserDefaultsFilterManager alloc] initWithUserDefaults:userDefaults eventStore:self.eventStore];
    
    // Calendar manager
    EKEventStore *calendarStore = [[EKEventStore alloc] init];
    self.calendarManager = [[UserDefaultsCalendarManager alloc] initWithUserDefaults:userDefaults calendarStore:calendarStore];
//    [self.calendarManager registerDefaultDefaultAlertTimeInterval:30];
    
    // Inject dependencies
    TabBarController *tabBarController = (TabBarController *)self.window.rootViewController;
    tabBarController.eventStore = self.eventStore;
    tabBarController.filterManager = self.filterManager;
    tabBarController.calendarManager = self.calendarManager;
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Refreshing...");
    [self.eventStore refresh];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Closing...");
    [self.eventStore save:NULL];
    [self.filterManager save];
    [self.calendarManager save];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // TIPS: This method might not be called.
}


#pragma mark - Notifications

- (void)eventStoreDidFailNotification:(NSNotification *)note
{
    // From -save:
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    abort();
    
    NSError *error = [note userInfo][EventStoreErrorUserInfoKey];
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
}


#pragma mark - CoreData stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EventKit" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EventKit.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] == nil) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Styles

- (void)setUpStyles
{
    // Styles
    //    UIColor *darkText = [UIColor colorWithHue:0 saturation:0 brightness:(20.0/100.0) alpha:1];
    
    // Navigation bar
//    UIColor *navigationBarText = [UIColor colorWithHue:0 saturation:0 brightness:(78.0/100.0) alpha:1];
    UIColor *navigationBarText = [UIColor colorWithHue:0 saturation:0 brightness:(100.0/100.0) alpha:1];
    [[UINavigationBar appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: navigationBarText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:20]}];
    
    // Bar button item
    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: navigationBarText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:12]} forState:UIControlStateNormal];
    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: navigationBarText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:12]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setTintColor:[UIColor blackColor]];
    
    // Segmented control
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setTintColor:[UIColor darkGrayColor]];
    
//    UIImage *barButtonItemImage = [UIImage imageNamed:@"BarButtonItem-Normal"];
//    UIImage *highlightedBarButtonItemImage = [UIImage imageNamed:@"BarButtonItem-Highlighted"];
//    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:barButtonItemImage forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:highlightedBarButtonItemImage forState:UIControlStateHighlighted style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];

// Back button
//    UIImage *backButtonImage = [UIImage imageNamed:@"BackButton-Normal"];
//    UIImage *highlightedBackButtonImage = [UIImage imageNamed:@"BackButton-Highlighted"];
//    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonBackgroundImage:highlightedBackButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem  appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(3, 0) forBarMetrics:UIBarMetricsDefault];

// Table view section header


//    [[UIBarButtonItem appearance] setBackbutt];

//    // Set background color of table views
//    UIColor *tableViewBackgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
//    [[UITableView appearance] setBackgroundView:nil];
//    [[UITableView appearance] setBackgroundColor:tableViewBackgroundColor];
//
//    // Set text color of navigation bar
////    UIColor *navigationBarTextColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1];
////    [[UILabel appearanceWhenContainedIn:[UINavigationBar class], nil] setColor:navigationBarTextColor];
////    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeTextColor: navigationBarTextColor}];
//
//    // TODO: More
//    UIColor *darkGray = [UIColor colorWithHue:0.67 saturation:0.2 brightness:0.15 alpha:1];
//    UIColor *gray = [UIColor colorWithHue:0 saturation:0 brightness:0.4 alpha:0.8];
//    [[UINavigationBar appearance] setTintColor:darkGray];
//    [[UITabBar appearance] setTintColor:darkGray];
//    [[UISearchBar appearance] setTintColor:darkGray];
//    [[UITableViewHeaderFooterView appearance] setTintColor:gray];
////    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setColor:[UIColor redColor]];
}

@end
