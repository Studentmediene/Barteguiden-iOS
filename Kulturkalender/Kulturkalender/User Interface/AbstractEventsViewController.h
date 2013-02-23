//
//  AbstractEventsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsSearchDisplayControllerDelegate.h"
#import "EventKitUI.h"

@protocol EventStore;
@class EventResultsController;

@interface AbstractEventsViewController : UITableViewController <EventsSearchDisplayControllerDelegate, EventResultsControllerDelegate>

@property (nonatomic, strong) id<EventStore> eventStore;

@property (nonatomic, strong) EventResultsController *eventResultsController;

- (void)reloadPredicate;
- (NSPredicate *)eventsPredicate;

@end
