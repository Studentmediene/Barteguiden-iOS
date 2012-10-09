//
//  EventsSearchDisplayController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsSearchDisplayControllerDelegate;

@interface EventsSearchDisplayController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet id<EventsSearchDisplayControllerDelegate> delegate;

@end
