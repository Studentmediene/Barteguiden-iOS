//
//  EventDetailsViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@protocol EventStore;
@protocol Event;
@protocol CalendarManager;
@class RIOExpandableLabel;


@interface EventDetailsViewController : UITableViewController <EKEventEditViewDelegate>

@property (nonatomic, strong) id<EventStore> eventStore; // FIXME: Remember to inject event store
@property (nonatomic, strong) id<Event> event;
@property (nonatomic, strong) id<CalendarManager> calendarManager;

//@property (nonatomic, strong) UIActivityViewController *activityViewController;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLimitLabel;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;

@property (nonatomic, weak) IBOutlet UIButton *calendarButton;

@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) IBOutlet UIImageView *ageLimitBorderView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ageLimitBorderWidthConstraint;

- (IBAction)toggleFavorite:(id)sender;
- (IBAction)toggleCalendarEvent:(id)sender;

@end
