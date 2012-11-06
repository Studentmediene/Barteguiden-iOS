//
//  AbstractEventsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsSearchDisplayControllerDelegate.h"

@interface AbstractEventsViewController : UITableViewController <NSFetchedResultsControllerDelegate, EventsSearchDisplayControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)reloadPredicate;
- (NSPredicate *)predicate;

@end
