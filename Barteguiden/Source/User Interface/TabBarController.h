//
//  TabBarController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventStore;
@protocol FilterManager;
@protocol CalendarManager;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) id<EventStore> eventStore;
@property (nonatomic, strong) id<FilterManager> filterManager;
@property (nonatomic, strong) id<CalendarManager> calendarManager;

- (IBAction)presentSettings:(id)sender;
- (IBAction)dismissSettings:(UIStoryboardSegue *)segue;

- (id)initWithEventStore:(id<EventStore>)eventStore filterManager:(id<FilterManager>)filterManager calendarManager:(id<CalendarManager>)calendarManager;

@end
