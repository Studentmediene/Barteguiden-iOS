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

@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"granted:%d error:%@", granted, error);
    }];
    
    NSLog(@"%@", [self.eventStore eventWithIdentifier:@"4874E572-D9CD-4617-9D28-60BA9B4083CC:1A543AEC-8A68-4612-BE0A-7BC5CF2FEC71"]);
    
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
    
//    EKEvent *calendarEvent = [EKEvent eventWithEventStore:self.eventStore];
//    calendarEvent.title = self.event.title;
//    calendarEvent.location = self.event.placeName;
//    calendarEvent.calendar = [self.eventStore defaultCalendarForNewEvents];
//    calendarEvent.startDate = [NSDate dateWithTimeIntervalSinceNow:60*60*10];
//    calendarEvent.endDate = [calendarEvent.startDate dateByAddingTimeInterval:60*60*1];
//    
//	EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
//    eventEditViewController.event = calendarEvent;
//	eventEditViewController.eventStore = self.eventStore;
//	eventEditViewController.editViewDelegate = self;
    
    
    EKEventViewController *eventViewController = [[EKEventViewController alloc] init];
    eventViewController.event = [self.eventStore eventWithIdentifier:@"4874E572-D9CD-4617-9D28-60BA9B4083CC:4A01BF5A-106B-4E61-A7AB-1B02B7271C85"];
    eventViewController.allowsEditing = NO;
    eventViewController.allowsCalendarPreview = NO;
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:eventViewController];
	[self presentViewController:navCtrl animated:YES completion:NULL];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self addToCalendar:actionSheet];
}

#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store,
			// and reload table view.
			// If the new event is being added to the default calendar, then update its
			// eventsList.
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            NSLog(@"Saved event:%@", controller.event.eventIdentifier);
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store,
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its
			// eventsList.
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			break;
			
		default:
			break;
	}
    
	[controller dismissViewControllerAnimated:YES completion:NULL];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
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

@end
