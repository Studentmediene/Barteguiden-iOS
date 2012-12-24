//
//  TabBarController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "TabBarController.h"
#import "EventManager.h"
#import "FilterManager.h"

#import "FeaturedViewController.h"
#import "AllEventsViewController.h"
#import "MyPageViewController.h"
#import "FavoritesViewController.h"

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Inject dependencies
    for (UINavigationController *navigationController in self.viewControllers) {
        UIViewController *rootViewController = navigationController.viewControllers[0];
        
        if ([rootViewController isKindOfClass:[AbstractEventsViewController class]] == YES) {
            AbstractEventsViewController *abstractEventsViewController = (AbstractEventsViewController *)rootViewController;
            abstractEventsViewController.eventManager = self.eventManager;
        }
        
        if ([rootViewController isKindOfClass:[MyPageViewController class]] == YES) {
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
