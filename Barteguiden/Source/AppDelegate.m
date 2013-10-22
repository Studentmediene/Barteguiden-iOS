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

#import "ApplicationNetworkActivity.h"

#import "TabBarController.h"

#import "EventResultsController.h"

#import <PSPDFAlertView.h>

#import "WebsiteViewController.h" // TODO: Needs the notifications -> Should move to a separate header file


static CGSize const kSettingsTabSize = {64, 49};


@interface AppDelegate ()

@property (nonatomic, strong) TabBarController *tabBarController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tabBarController = (TabBarController *)self.window.rootViewController;
    
//    self.window.tintColor = [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f];
    
    [self setUpTabBarStyles];
    
    // User defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.networkActivity = [[ApplicationNetworkActivity alloc] initWithApplication:[UIApplication sharedApplication]];
    
    // Event store
    self.eventStore = [[CoreDataEventStore alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreWillDownloadData:) name:EventStoreWillDownloadDataNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreDidDownloadData:) name:EventStoreDidDownloadDataNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreDidFail:) name:EventStoreDidFailNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    
    // Filter manager
    self.filterManager = [[UserDefaultsFilterManager alloc] initWithUserDefaults:userDefaults eventStore:self.eventStore];
    
    // Calendar manager
    EKEventStore *calendarStore = [[EKEventStore alloc] init];
    self.calendarManager = [[UserDefaultsCalendarManager alloc] initWithUserDefaults:userDefaults calendarStore:calendarStore];
//    [self.calendarManager registerDefaultDefaultAlertTimeInterval:-30*60]; // TODO: If I uncomment this line, I can't select None as Default Alert
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarManagerDidFail:) name:CalendarManagerDidFailNotification object:self.calendarManager];
    
    // Website notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreWillDownloadData:) name:WebsiteWillDownloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreDidDownloadData:) name:WebsiteDidDownloadDataNotification object:nil];
    
    // Inject dependencies
//    TabBarController *tabBarController = [[TabBarController alloc] initWithEventStore:self.eventStore filterManager:self.filterManager calendarManager:self.calendarManager];
//    tabBarController.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.tabBarController.eventStore = self.eventStore;
    self.tabBarController.filterManager = self.filterManager;
    self.tabBarController.calendarManager = self.calendarManager;
    
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
    [self.eventStore save:NULL]; // TODO: Fix error handling
    [self.filterManager save];
    [self.calendarManager save];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // TIPS: This method might not be called.
}


#pragma mark - Notifications

- (void)eventStoreWillDownloadData:(NSNotification *)note
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.networkActivity incrementNetworkActivity];
}

- (void)eventStoreDidDownloadData:(NSNotification *)note
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.networkActivity decrementNetworkActivity];
}

- (void)eventStoreDidFail:(NSNotification *)note
{
    NSError *error = note.userInfo[EventStoreErrorUserInfoKey];
    switch (error.code) {
        case EventStoreSaveFailed: {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //    abort();
            break;
        }
    }
    
    NSLog(@"Unresolved error:%@", error);
}

- (void)eventStoreChanged:(NSNotification *)note
{
    NSUInteger insertedCount = [note.userInfo[EventStoreInsertedEventsUserInfoKey] count];
    NSUInteger updatedCount = [note.userInfo[EventStoreUpdatedEventsUserInfoKey] count];
    NSUInteger deletedCount = [note.userInfo[EventStoreDeletedEventsUserInfoKey] count];
    NSLog(@"Inserted:%d updated:%d deleted:%d", insertedCount, updatedCount, deletedCount);
    
    if (insertedCount > 0 || deletedCount > 0) {
        [EventResultsController clearCache];
    }
}

- (void)calendarManagerDidFail:(NSNotification *)note
{
    NSError *error = note.userInfo[CalendarManagerErrorUserInfoKey];
    switch (error.code) {
        case CalendarManagerAuthorizationFailed: {
            NSString *title = NSLocalizedStringWithDefaultValue(@"CALENDAR_AUTHORIZATION_FAILED_TITLE", nil, [NSBundle mainBundle], @"Can't Access Calendar", @"Title of alert view (Displayed when calendar authorization fails)");
            NSString *message = NSLocalizedStringWithDefaultValue(@"CALENDAR_AUTHORIZATION_FAILED_MESSAGE", nil, [NSBundle mainBundle], @"To access your calendar, go to Settings > Privacy > Calendar, and set the Barteguiden switch to On.", @"Message of alert view (Displayed when calendar authorization fails)");
            NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"CALENDAR_AUTHORIZATION_FAILED_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"Close", @"Name of cancel button of alert view (Displayed when calendar authorization fails)");
            
            UIAlertView *enableCalendarAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [enableCalendarAlertView show];
            break;
        }
    }
    
    NSLog(@"Unresolved error:%@", error);
}


#pragma mark - Styles

- (void)setUpTabBarStyles
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    
//    UITabBarItem *featuredTab = tabBar.items[0];
    UITabBarItem *allEventsTab = tabBar.items[1];
    UITabBarItem *myFilterTab = tabBar.items[2];
    UITabBarItem *favoritesTab = tabBar.items[3];
    UITabBarItem *settingsTab = tabBar.items[4];
    
    allEventsTab.image = [UIImage imageNamed:@"AllEventsTab-Normal"];
    allEventsTab.selectedImage = [UIImage imageNamed:@"AllEventsTab-Selected"];
    myFilterTab.image = [UIImage imageNamed:@"MyFilterTab-Normal"];
    myFilterTab.selectedImage = [UIImage imageNamed:@"MyFilterTab-Selected"];
    favoritesTab.image = [UIImage imageNamed:@"FavoritesTab-Normal"];
    favoritesTab.selectedImage = [UIImage imageNamed:@"FavoritesTab-Selected"];
    settingsTab.image = [UIImage imageNamed:@"SettingsTab-Normal"];
    settingsTab.selectedImage = [UIImage imageNamed:@"SettingsTab-Selected"];
}

@end
