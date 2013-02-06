//
//  TabBarController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventStore;
@protocol FilterManager;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) id<EventStore> eventStore;
@property (nonatomic, strong) id<FilterManager> filterManager;

@end
