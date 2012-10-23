//
//  AbstractEventsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "EventsSearchDisplayControllerDelegate.h"

//@class EventsSearchDisplayController;

@interface AbstractEventsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong) IBOutlet EventsSearchDisplayController *eventsSearchDisplayController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)reloadPredicate;
- (NSPredicate *)tabPredicate;
- (NSPredicate *)searchPredicate;

@end
