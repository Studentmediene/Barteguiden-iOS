//
//  TabBarController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "TabBarController.h"
#import "EventKit.h"

#import "UserDefaultsFilterManager.h"
#import "AbstractEventsViewController.h"
#import "MyPageViewController.h"
#import "EventsSearchDisplayController.h"

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
            
            EventsSearchDisplayController *eventsSearchDisplayController = (EventsSearchDisplayController *)abstractEventsViewController.searchDisplayController.delegate;
            eventsSearchDisplayController.eventStore = self.eventStore;
        }
        
        if ([rootViewController isKindOfClass:[MyPageViewController class]]) {
            MyPageViewController *myPageViewController = (MyPageViewController *)rootViewController;
            myPageViewController.filterManager = self.filterManager;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
