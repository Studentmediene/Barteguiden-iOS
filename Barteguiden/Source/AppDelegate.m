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


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpStyles];
    
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
    
    // Inject dependencies
    TabBarController *tabBarController = (TabBarController *)self.window.rootViewController;
//    TabBarController *tabBarController = [[TabBarController alloc] initWithEventStore:self.eventStore filterManager:self.filterManager calendarManager:self.calendarManager];
//    tabBarController.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    tabBarController.eventStore = self.eventStore;
    tabBarController.filterManager = self.filterManager;
    tabBarController.calendarManager = self.calendarManager;
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = tabBarController;
//    [self.window makeKeyAndVisible];
    
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

- (void)setUpStyles
{
    // Navigation bar
    UIColor *barText = [UIColor colorWithHue:0 saturation:0 brightness:(78.0/100.0) alpha:1];
    [[UINavigationBar appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: barText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:20]}];
    
    // Toolbar
    [[UIToolbar appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class],[TabBarController class], nil] setTintColor:barText];
    
    // Bar button item text styles
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: barText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:13]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: barText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:13]} forState:UIControlStateHighlighted];
    
    // Back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"BackButton-Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)];
    UIImage *highlightedBackButtonImage = [[UIImage imageNamed:@"BackButton-Highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonBackgroundImage:highlightedBackButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    
    // Bar button item
    UIImage *barButtonItemImage = [UIImage imageNamed:@"BarButtonItem-Normal"];
    UIImage *highlightedBarButtonItemImage = [UIImage imageNamed:@"BarButtonItem-Highlighted"];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:barButtonItemImage forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:highlightedBarButtonItemImage forState:UIControlStateHighlighted style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    
    // Bar button item done
    UIImage *barButtonItemDoneImage = [UIImage imageNamed:@"BarButtonItemDone-Normal"];
    UIImage *highlightedBarButtonItemDoneImage = [UIImage imageNamed:@"BarButtonItemDone-Highlighted"];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:barButtonItemDoneImage forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:highlightedBarButtonItemDoneImage forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];

    // Segmented control
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: barText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:13]} forState:UIControlStateNormal];
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"SegmentedControlBackground-Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:unselectedBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"SegmentedControlBackground-Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    UIImage *bothUnselectedImage = [UIImage imageNamed:@"SegmentedControlDivider-BothNormal"];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setDividerImage:bothUnselectedImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *rightSelectedImage = [UIImage imageNamed:@"SegmentedControlDivider-RightSelected"];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setDividerImage:rightSelectedImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    UIImage *leftSelectedImage = [UIImage imageNamed:@"SegmentedControlDivider-LeftSelected"];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setDividerImage:leftSelectedImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setContentPositionAdjustment:UIOffsetMake(1, 0) forSegmentType:UISegmentedControlSegmentLeft barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearanceWhenContainedIn:[TabBarController class], nil] setContentPositionAdjustment:UIOffsetMake(-1, 0) forSegmentType:UISegmentedControlSegmentRight barMetrics:UIBarMetricsDefault];
    
    // Tab bar
    [[UITabBar appearanceWhenContainedIn:[TabBarController class], nil] setBackgroundImage:[UIImage imageNamed:@"TabBarBackground"]];
    [[UITabBar appearanceWhenContainedIn:[TabBarController class], nil] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarSelectedTab"]];
    [[UITabBarItem appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: barText, UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearanceWhenContainedIn:[TabBarController class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:10]} forState:UIControlStateSelected];
}

@end
