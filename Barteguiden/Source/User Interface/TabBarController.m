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
#import "MyFilterViewController.h"
#import "EventsSearchDisplayController.h"
#import "SettingsViewController.h"

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Inject dependencies
    NSLog(@"Injecting dependencies");
    for (UINavigationController *navigationController in self.viewControllers) {
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
        
        if ([rootViewController isKindOfClass:[SettingsViewController class]]) {
            SettingsViewController *settingsViewController = (SettingsViewController *)rootViewController;
            settingsViewController.calendarManager = self.calendarManager;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
