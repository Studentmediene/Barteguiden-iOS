//
//  EventsSearchDisplayController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractEventsViewController.h"

@protocol EventsSearchDisplayControllerDelegate;

@interface EventsSearchDisplayController : AbstractEventsViewController <UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet id<EventsSearchDisplayControllerDelegate> delegate;

@end
