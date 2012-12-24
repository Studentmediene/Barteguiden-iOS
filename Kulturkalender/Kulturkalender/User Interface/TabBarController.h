//
//  TabBarController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventManager;
@protocol FilterManager;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) id<EventManager> eventManager;
@property (nonatomic, strong) id<FilterManager> filterManager;

@property (nonatomic, weak) IBOutlet id test;

@end
