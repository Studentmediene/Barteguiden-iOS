//
//  EventDetailsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventManager.h"
#import "MapViewController.h"

const float kAlertOffset = -30*60; // 30 minutes before event

@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"granted:%d error:%@", granted, error);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChanged:) name:EKEventStoreChangedNotification object:eventStore];
    
    self.eventStore = eventStore;
    
    [self updateViewInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapSegue"])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.annotation = self.event.annotation;
    }
}


#pragma mark - IBAction

- (void)toggleFavorite:(id)sender
{
    BOOL isFavorite = ([self.event.favorite boolValue] == NO);
    
    self.event.favorite = @(isFavorite);
    
    self.favoriteButton.selected = isFavorite;
}

- (void)shareEvent:(id)sender
{
    NSArray *activityItems = @[ [UIImage imageNamed:@"EmptyPoster.png"], @"Test" ];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)promptDateActions:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // TODO: Localize
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Create Event", @"Show in Calendar", @"Copy", nil];
    [actionSheet showInView:self.view];
}

- (void)addToCalendar:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    EKEvent *calendarEvent = [EKEvent eventWithEventStore:self.eventStore];
    calendarEvent.calendar = [self.eventStore defaultCalendarForNewEvents];
    calendarEvent.title = self.event.title;
    calendarEvent.location = self.event.placeName;
    calendarEvent.startDate = self.event.startAt;
    calendarEvent.endDate = self.event.endAt;
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:kAlertOffset];
    [calendarEvent addAlarm:alarm];
    
	EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.event = calendarEvent;
	eventEditViewController.eventStore = self.eventStore;
	eventEditViewController.editViewDelegate = self;
    
	[self presentViewController:eventEditViewController animated:YES completion:NULL];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self addToCalendar:actionSheet];
}

#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
	switch (action) {
		case EKEventEditViewActionCanceled: {
			break;
        }
		case EKEventEditViewActionSaved: {
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:nil];
            
            NSLog(@"Saved event:%@", controller.event.eventIdentifier);
			break;
        }
		case EKEventEditViewActionDeleted: {
			[controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:nil];
			break;
        }
	}
    
	[controller dismissViewControllerAnimated:YES completion:NULL];
}

- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    NSLog(@"%@", NSStringFromSelector(_cmd));
	EKCalendar *calendarForEdit = [self.eventStore defaultCalendarForNewEvents];
	return calendarForEdit;
}


#pragma mark - Private methods

- (void)updateViewInfo
{
    self.titleLabel.text = self.event.title;
    self.timeLabel.text = self.event.timeString;
    self.categoryLabel.text = self.event.categoryString;
    self.priceLabel.text = self.event.priceString;
    self.ageLimitLabel.text = self.event.ageLimitString;
    self.descriptionLabel.text = self.event.currentLocalizedDescription;
    
    self.featuredLabel.text = self.event.currentLocalizedFeatured;
    
    self.placeNameLabel.text = self.event.placeName;
    self.addressLabel.text = self.event.address;
    
    self.favoriteButton.selected = [self.event.favorite boolValue];
}

- (void)storeChanged:(NSNotification *)note
{
    NSLog(@"Store changed:%@", note);
    // TIPS: If you are currently modifying an event and you do not want to refetch it unless it is absolutely necessary to do so, you can call the refresh method on the event. If the method returns YES, you can continue to use the event; otherwise, you need to refetch it.
}

@end
