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


const NSInteger kActionSheetCancelButtonIndex = 1;

static NSString * const kPosterSegue = @"Poster";
static NSString * const kMapSegue = @"MapSegue";


@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: Does not work to add events to calendar anymore :-/
    self.calendarStore = [[EKEventStore alloc] init]; // TODO: Inject instead?
    [self requestAccessToCalendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarStoreChanged:) name:EKEventStoreChangedNotification object:self.calendarStore];
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
        posterViewController.poster = [self.event imageWithSize:CGSizeZero];
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
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)promptDateActions:(id)sender
{
    // TODO: Fix localization
    NSString *createEventTitle = NSLocalizedString(@"Add to Calendar", nil);
    NSString *deleteEventTitle = NSLocalizedString(@"Delete from Calendar", nil);
    NSString *editEventTitle = NSLocalizedString(@"Edit in Calendar", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    
    UIActionSheet *actionSheet = nil;
    if ([self isAddedToCalendar] == NO) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:createEventTitle, nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:deleteEventTitle otherButtonTitles:editEventTitle, nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)addToCalendar:(id)sender
{
    EKEvent *calendarEvent = [EKEvent eventWithEventStore:self.calendarStore];
    calendarEvent.calendar = [self.calendarStore defaultCalendarForNewEvents];
    calendarEvent.title = self.event.title;
    calendarEvent.location = self.event.placeName;
    calendarEvent.startDate = self.event.startAt;
    
    const float kAlertOffset = -30*60; // TODO: Get from settings
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:kAlertOffset];
    [calendarEvent addAlarm:alarm];
    
	EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.event = calendarEvent;
	eventEditViewController.eventStore = self.calendarStore;
	eventEditViewController.editViewDelegate = self;
    
	[self presentViewController:eventEditViewController animated:YES completion:NULL];
}

- (void)removeFromCalendar:(id)sender
{
    EKEvent *calendarEvent = [self.calendarStore eventWithIdentifier:[self.event calendarEventID]];
    [self removeCalendarEvent:calendarEvent];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kActionSheetCancelButtonIndex) {
        return;
    }
    
    if ([self isAddedToCalendar] == NO) {
        [self addToCalendar:actionSheet];
    }
    else {
        [self removeFromCalendar:actionSheet];
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
    self.calendarStatusLabel.text = @"No access";
    
    __weak typeof(self) bself = self;
    [self.calendarStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            bself.calendarStatusLabel.text = @"Access";
        }
//        NSLog(@"granted:%d error:%@", granted, error);
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
    
    UIImage *image = [self.event imageWithSize:CGSizeZero];
    self.posterButton.enabled = (image != nil) ? YES : NO;
    self.posterButton.imageView.image = image ?: [UIImage imageNamed:@"EmptyPoster"]; // TODO: Fix size
    
    self.titleLabel.text = [self.event title];
    self.timeLabel.text = [eventFormatter timeString];
    self.categoryLabel.text = [eventFormatter categoryString];
    self.priceLabel.text = [eventFormatter priceString];
    self.ageLimitLabel.text = [eventFormatter ageLimitString];
    self.descriptionLabel.text = [eventFormatter currentLocalizedDescription];
    
    self.featuredLabel.text = [eventFormatter currentLocalizedFeatured];
    
    self.placeNameLabel.text = [self.event placeName];
    self.addressLabel.text = [self.event address];
    
    self.favoriteButton.selected = [self.event isFavorite];
    
    self.calendarStatusLabel.text = ([self isAddedToCalendar] == YES) ? @"Is added to calendar" : @"Is NOT added to calendar"; // TODO: Temp
}

@end
