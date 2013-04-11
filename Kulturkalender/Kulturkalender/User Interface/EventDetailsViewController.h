//
//  EventDetailsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@protocol EventStore;
@protocol Event;

@interface EventDetailsViewController : UIViewController <UIActionSheetDelegate, EKEventEditViewDelegate>

@property (nonatomic, strong) id<EventStore> eventStore;
@property (nonatomic, strong) id<Event> event;

//@property (nonatomic, strong) id<SettingsManager> settingsManager;
@property (nonatomic, strong) EKEventStore *calendarStore;

//@property (nonatomic, strong) UIActivityViewController *activityViewController;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *calendarImageView;
@property (nonatomic, weak) IBOutlet UILabel *calendarActionLabel;
@property (nonatomic, weak) IBOutlet UIButton *calendarButton;

@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) IBOutlet UILabel *descriptionTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (IBAction)toggleFavorite:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)modifyCalendar:(id)sender;
- (IBAction)visitWebsite:(id)sender;

@end
