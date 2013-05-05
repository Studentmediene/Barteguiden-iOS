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
#import "RIOExpandableLabelDelegate.h"

@protocol EventStore;
@protocol Event;
@protocol CalendarManager;
@class RIOExpandableLabel;


@interface EventDetailsViewController : UIViewController <UIActionSheetDelegate, EKEventEditViewDelegate, RIOExpandableLabelDelegate>

@property (nonatomic, strong) id<EventStore> eventStore; // FIXME: Is this one really necessary?
@property (nonatomic, strong) id<Event> event;
@property (nonatomic, strong) id<CalendarManager> calendarManager;

//@property (nonatomic, strong) UIActivityViewController *activityViewController;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;

@property (nonatomic, weak) IBOutlet UIImageView *calendarImageView;
@property (nonatomic, weak) IBOutlet UILabel *calendarActionLabel;
@property (nonatomic, weak) IBOutlet UIButton *calendarButton;

@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) IBOutlet UILabel *descriptionTitleLabel;
@property (nonatomic, weak) IBOutlet RIOExpandableLabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;

@property (nonatomic, weak) IBOutlet UIButton *visitWebsiteButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showOnMapConstraint;
@property (nonatomic, weak) IBOutlet UIButton *showOnMapButton;

- (IBAction)toggleFavorite:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)modifyCalendar:(id)sender;
- (IBAction)visitWebsite:(id)sender;

@end
