//
//  EventDetailsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventKit.h"
#import "EventKitUI.h"

#import "PosterViewController.h"
#import "MapViewController.h"


static NSString * const kPosterSegue = @"PosterSegue";
static NSString * const kMapSegue = @"MapSegue";

static CGSize const kThumbnailSize = {72, 72};


@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: Does not work to add events to calendar anymore :-/
    self.calendarStore = [[EKEventStore alloc] init]; // TODO: Inject instead?
    [self requestAccessToCalendar];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareEvent:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Action"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareEvent:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarStoreChanged:) name:EKEventStoreChangedNotification object:self.calendarStore];
    
    UIImage *modifyCalendarButtonImage = [UIImage imageNamed:@"TextHighlight"];
    UIImage *stretchableModifyCalendarButtonImage = [modifyCalendarButtonImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    [self.calendarButton setBackgroundImage:stretchableModifyCalendarButtonImage forState:UIControlStateHighlighted];

    // TODO: Use this code to make a border around age limit
//    self.priceLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.priceLabel.layer.borderWidth = 2;
//    self.priceLabel.layer.cornerRadius = 2;
    
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:30];
    self.locationLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.priceLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.ageLimitLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.timeLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
    
    self.descriptionTitleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    self.descriptionLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViewInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:self.calendarStore];
}


#pragma mark - Notification callbacks

- (void)eventStoreChanged:(NSNotification *)note
{
    // TODO: Check if it is the correct calendar event that is updated?
    // TIPS: If you are currently modifying an event and you do not want to refetch it unless it is absolutely necessary to do so, you can call the refresh method on the event. If the method returns YES, you can continue to use the event; otherwise, you need to refetch it.
    [self updateViewInfo];
}

- (void)calendarStoreChanged:(NSNotification *)note
{
    // TODO: Check if it is the correct calendar event that is updated?
    [self updateViewInfo];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPosterSegue])
    {
        PosterViewController *posterViewController = [segue destinationViewController];
        posterViewController.poster = [self.event originalImage];
    }
    else if ([segue.identifier isEqualToString:kMapSegue])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.annotation = [[EventAnnotation alloc] initWithEvent:self.event];
    }
}


#pragma mark - IBAction

- (void)toggleFavorite:(id)sender
{
    BOOL newFavorite = ([self.event isFavorite] == NO);

    self.event.favorite = newFavorite;
    self.favoriteButton.selected = newFavorite;
}

- (void)shareEvent:(id)sender
{
    NSString *eventAd = [NSString stringWithFormat:@"Join me at %@!", [self.event title]];
    NSArray *activityItems = @[eventAd];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)modifyCalendar:(id)sender
{
    if ([self isAddedToCalendar] == NO) {
        [self addToCalendar:sender];
    }
    else {
        [self promptRemoveFromCalendar:sender];
    }
}

- (IBAction)addToCalendar:(id)sender
{
    const float kAlertOffset = -30*60; // TODO: Get from settings
    const float kOneHourOffset = 60*60;
    
    EKEvent *calendarEvent = [EKEvent eventWithEventStore:self.calendarStore];
    calendarEvent.calendar = [self.calendarStore defaultCalendarForNewEvents];
    calendarEvent.title = self.event.title;
    calendarEvent.location = self.event.placeName;
    calendarEvent.startDate = self.event.startAt;
    calendarEvent.endDate = [[self.event startAt] dateByAddingTimeInterval:kOneHourOffset];
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:kAlertOffset];
    [calendarEvent addAlarm:alarm];
    
	EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.event = calendarEvent;
	eventEditViewController.eventStore = self.calendarStore; // TODO: Get from settings
	eventEditViewController.editViewDelegate = self;
    
//    UIColor *tableViewBackgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
//    eventEditViewController.view.backgroundColor = tableViewBackgroundColor;
    
	[self presentViewController:eventEditViewController animated:YES completion:NULL];
}

- (IBAction)promptRemoveFromCalendar:(id)sender
{
    // TODO: Fix localization
    NSString *deleteTitle = NSLocalizedString(@"Remove from Calendar", nil);
    NSString *editTitle = NSLocalizedString(@"Edit in Calendar", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:deleteTitle otherButtonTitles:editTitle, nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)editInCalendar:(id)sender
{
    NSLog(@"Editing...");
}

- (IBAction)removeFromCalendar:(id)sender
{
    EKEvent *calendarEvent = [self.calendarStore eventWithIdentifier:[self.event calendarEventID]];
    [self removeCalendarEvent:calendarEvent];
}

- (IBAction)visitWebsite:(id)sender
{
    NSURL *url = [self.event URL];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if ([self isAddedToCalendar] == YES) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [self removeFromCalendar:actionSheet];
        }
        else {
            [self editInCalendar:actionSheet];
        }
    }
}


#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	switch (action) {
		case EKEventEditViewActionCanceled: {
			break;
        }
		case EKEventEditViewActionSaved: {
			[self addCalendarEvent:controller.event];
			break;
        }
		case EKEventEditViewActionDeleted: {
			[self removeCalendarEvent:controller.event];
			break;
        }
	}
    
	[controller dismissViewControllerAnimated:YES completion:NULL];
}

- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    // TODO: Return calendar from settings
    NSLog(@"%@", NSStringFromSelector(_cmd));
	EKCalendar *calendarForEdit = [self.calendarStore defaultCalendarForNewEvents];
	return calendarForEdit;
}


#pragma mark - Private methods

- (void)requestAccessToCalendar
{
    [self.calendarStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"granted:%d error:%@", granted, error);
    }];
}

- (BOOL)isAddedToCalendar
{
    return ([[self.event calendarEventID] length] > 0);
}

- (void)addCalendarEvent:(EKEvent *)calendarEvent
{
    NSLog(@"Adding event to calendar:%@", calendarEvent.eventIdentifier);
    [self.calendarStore saveEvent:calendarEvent span:EKSpanThisEvent error:NULL];
    [self.event setCalendarEventID:calendarEvent.eventIdentifier];
}

- (void)removeCalendarEvent:(EKEvent *)calendarEvent
{
    NSLog(@"Removing event from calendar:%@", calendarEvent.eventIdentifier);
    [self.calendarStore removeEvent:calendarEvent span:EKSpanThisEvent error:NULL];
    [self.event setCalendarEventID:nil];
}

- (void)updateViewInfo
{
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:self.event];
    
//    UIImage *image = [self.event imageWithSize:kThumbnailSize];
//    if (image != nil) {
//        [self.posterButton setImage:image forState:UIControlStateNormal];
//    }
    
    self.titleLabel.text = [self.event title];
    self.locationLabel.text = [self.event placeName];
    self.timeLabel.text = [eventFormatter timeString];
    self.priceLabel.text = [eventFormatter priceString];
    
    NSString *ageLimit = [NSString stringWithFormat:@"%d+", [self.event ageLimit]];
    self.ageLimitLabel.text = ageLimit;
    
    self.descriptionLabel.text = [eventFormatter currentLocalizedDescription];
    
    self.favoriteButton.selected = [self.event isFavorite];
    
    // TODO: Fix localization
    NSString *addToCalendar = NSLocalizedString(@"Add to Calendar", nil);
    NSString *removeFromCalendar = NSLocalizedString(@"Remove from Calendar", nil);
    NSString *calendarActionTitle = ([self isAddedToCalendar] == NO) ? addToCalendar : removeFromCalendar;
    
    self.calendarActionLabel.text = calendarActionTitle;
    self.calendarImageView.image = ([self isAddedToCalendar] == NO) ? [UIImage imageNamed:@"Calendar-Normal"] : [UIImage imageNamed:@"Calendar-Selected"];
}

@end
