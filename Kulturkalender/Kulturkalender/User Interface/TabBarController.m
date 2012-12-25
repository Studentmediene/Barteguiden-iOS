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
#import "AbstractEventsViewController.h"
#import "MyPageViewController.h"

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Inject dependencies
    for (UINavigationController *navigationController in self.viewControllers) {
        UIViewController *rootViewController = navigationController.viewControllers[0];
        
        if ([rootViewController respondsToSelector:@selector(setEventManager:)]) {
            [rootViewController performSelector:@selector(setEventManager:) withObject:self.eventManager];
        }
        
        if ([rootViewController respondsToSelector:@selector(setFilterManager:)]) {
            [rootViewController performSelector:@selector(setFilterManager:) withObject:self.eventManager];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
