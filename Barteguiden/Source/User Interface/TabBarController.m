//
//  TabBarController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "TabBarController.h"

#import "EventKit.h"
#import "FilterManager.h"
#import "CalendarManager.h"

#import "AbstractEventsViewController.h"
#import "EventsSearchDisplayController.h"

#import "FeaturedViewController.h"
#import "AllEventsViewController.h"
#import "MyFilterViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"


static CGSize const kSettingsTabSize = {64, 49};


@interface TabBarController ()

@property (nonatomic, strong) EventResultsController *eventResultsController;

@end


@implementation TabBarController

- (id)initWithEventStore:(id<EventStore>)eventStore filterManager:(id<FilterManager>)filterManager calendarManager:(id<CalendarManager>)calendarManager
{
    self = [super init];
    if (self) {
        _eventStore = eventStore;
        _filterManager = filterManager;
        _calendarManager = calendarManager;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setUpTabs];
    [self setUpSettingsButton];
    [self setUpStyles];
    
    // Inject dependencies
    for (UIViewController *viewController in self.viewControllers) {
        
        if ([viewController isKindOfClass:[UINavigationController class]] == NO) {
            continue;
        }
        
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *rootViewController = navigationController.viewControllers[0];
        
        if ([rootViewController isKindOfClass:[AbstractEventsViewController class]]) {
            AbstractEventsViewController *abstractEventsViewController = (AbstractEventsViewController *)rootViewController;
            abstractEventsViewController.eventStore = self.eventStore;
            abstractEventsViewController.calendarManager = self.calendarManager;
            EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)abstractEventsViewController.searchDisplayController.delegate;
            eventsSearchDisplayController.eventStore = self.eventStore;
        }
        
        if ([rootViewController isKindOfClass:[MyFilterViewController class]]) {
            MyFilterViewController *myFilterViewController = (MyFilterViewController *)rootViewController;
            myFilterViewController.filterManager = self.filterManager;
        }
        
//        if ([rootViewController isKindOfClass:[SettingsViewController class]]) {
//            SettingsViewController *settingsViewController = (SettingsViewController *)rootViewController;
//            settingsViewController.calendarManager = self.calendarManager;
//        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)presentSettings:(id)sender
{
    UIViewController *settingsViewController = [self settingsViewController];
    [self presentViewController:settingsViewController animated:YES completion:NULL];
}

- (IBAction)dismissSettings:(UIStoryboardSegue *)segue
{
    NSLog(@"Closing settings...");
}


#pragma mark - Private methods

- (void)setUpTabs
{
    UIViewController *dummyViewController = [[UIViewController alloc] init];
    self.viewControllers = @[[self featuredViewController], dummyViewController];
//    self.viewControllers = @[[self featuredViewController], [self allEventsViewController], [self myFilterViewController], [self favoritesViewController], dummyViewController];
}

- (void)setUpSettingsButton
{
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(self.tabBar.bounds.size.width - kSettingsTabSize.width, 0, kSettingsTabSize.width, kSettingsTabSize.height);
        settingsButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarBackground"]];
    [settingsButton setImage:[UIImage imageNamed:@"SettingsButton"] forState:UIControlStateNormal];
    settingsButton.showsTouchWhenHighlighted = YES;
    [settingsButton addTarget:self action:@selector(presentSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:settingsButton];
}

- (void)setUpStyles
{
    UITabBarItem *featuredTab = self.tabBar.items[0];
    UITabBarItem *allEventsTab = self.tabBar.items[1];
    UITabBarItem *myFilterTab = self.tabBar.items[2];
    UITabBarItem *favoritesTab = self.tabBar.items[3];
    
    [featuredTab setFinishedSelectedImage:[UIImage imageNamed:@"FeaturedTab-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"FeaturedTab-Normal"]];
    [allEventsTab setFinishedSelectedImage:[UIImage imageNamed:@"AllEventsTab-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"AllEventsTab-Normal"]];
    [myFilterTab setFinishedSelectedImage:[UIImage imageNamed:@"MyFilterTab-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"MyFilterTab-Normal"]];
    [favoritesTab setFinishedSelectedImage:[UIImage imageNamed:@"FavoritesTab-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"FavoritesTab-Normal"]];
}

- (UIViewController *)featuredViewController
{
    FeaturedViewController *featuredViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Featured"];
//    FeaturedViewController *featuredViewController = [[FeaturedViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featuredViewController.eventStore = self.eventStore;
    featuredViewController.calendarManager = self.calendarManager;
    
    EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)featuredViewController.searchDisplayController.delegate;
    eventsSearchDisplayController.eventStore = self.eventStore;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:featuredViewController];
    return navigationController;
}

- (UIViewController *)allEventsViewController
{
    AllEventsViewController *allEventsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AllEvents"];
    allEventsViewController.eventStore = self.eventStore;
    allEventsViewController.calendarManager = self.calendarManager;
    
    EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)allEventsViewController.searchDisplayController.delegate;
    eventsSearchDisplayController.eventStore = self.eventStore;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:allEventsViewController];
    return navigationController;
}

- (UIViewController *)myFilterViewController
{
    MyFilterViewController *myFilterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFilter"];
    myFilterViewController.eventStore = self.eventStore;
    myFilterViewController.filterManager = self.filterManager; // NOTE: This different from the other controllers
    myFilterViewController.calendarManager = self.calendarManager;
    
    EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)myFilterViewController.searchDisplayController.delegate;
    eventsSearchDisplayController.eventStore = self.eventStore;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myFilterViewController];
    return navigationController;
}

- (UIViewController *)favoritesViewController
{
    FavoritesViewController *favoritesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Favorites"];
    favoritesViewController.eventStore = self.eventStore;
    favoritesViewController.calendarManager = self.calendarManager;
    
    EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)favoritesViewController.searchDisplayController.delegate;
    eventsSearchDisplayController.eventStore = self.eventStore;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    return navigationController;
}

- (UIViewController *)settingsViewController
{
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    settingsViewController.calendarManager = self.calendarManager;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    return navigationController;
}

- (UIStoryboard *)storyboard
{
    return [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
}

@end
