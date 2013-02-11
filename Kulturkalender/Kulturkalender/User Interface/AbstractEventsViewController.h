//
//  AbstractEventsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsSearchDisplayControllerDelegate.h"

@protocol EventStore;

@interface AbstractEventsViewController : UITableViewController <EventsSearchDisplayControllerDelegate>

@property (nonatomic, strong) id<EventStore> eventStore;

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSDictionary *items;

- (void)reloadPredicate;
- (NSPredicate *)eventsPredicate;

@end
