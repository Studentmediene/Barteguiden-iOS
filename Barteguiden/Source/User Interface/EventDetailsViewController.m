//
//  EventDetailsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventKit.h"
#import "EventKitUI.h"
#import "CalendarManager.h"
#import <RIOExpandableLabel.h>
#import "UIImage+RIODarkenAndBlur.h"
#import "MapViewController.h"


static NSString * const kPosterSegue = @"PosterSegue";
static NSString * const kMapSegue = @"MapSegue";

static CGSize const kThumbnailSize = {320, 200};
static float const kOneHourOffset = 1*60*60;


@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpStyles];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareEvent:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Action"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareEvent:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarStoreChanged:) name:EKEventStoreChangedNotification object:self.calendarManager.calendarStore];
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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:self.calendarManager.calendarStore];
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
//    [self updateViewInfo];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapSegue])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.annotation = [[EventAnnotation alloc] initWithEvent:self.event];
    }
}


#pragma mark - IBAction

- (IBAction)shareEvent:(id)sender
{
    NSString *eventAd = [NSString stringWithFormat:@"Join me at %@!", [self.event title]];
    NSArray *activityItems = @[eventAd];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)toggleFavorite:(id)sender
{
    BOOL newFavorite = ([self.event isFavorite] == NO);

    self.event.favorite = newFavorite;
    self.favoriteButton.selected = newFavorite;
    
    if ([self.calendarManager shouldAutoAddFavorites]) {
        [self.calendarManager requestAccessWithCompletion:^(BOOL granted, NSError *error) {
            if (granted == NO) {
                return;
            }
        
            if (newFavorite == YES && [self isAddedToCalendar] == NO) {
                EKEvent *calendarEvent = [self newCalendarEvent];
                [self addCalendarEvent:calendarEvent];
            }
            else if (newFavorite == NO && [self isAddedToCalendar] == YES) {
                EKEvent *calendarEvent = [self.calendarManager.calendarStore eventWithIdentifier:self.event.calendarEventID];
                [self removeCalendarEvent:calendarEvent];
            }
        }];
    }
}

- (IBAction)toggleCalendarEvent:(id)sender
{
    [self.calendarManager requestAccessWithCompletion:^(BOOL granted, NSError *error) {
        if (granted == NO) {
            return;
        }
    
        if ([self isAddedToCalendar] == NO) {
            [self presentNewCalendarEvent];
        }
        else {
            [self promptEditOrRemoveFromCalendar];
        }
    }];
}

- (IBAction)visitWebsite:(id)sender
{
    NSURL *url = [self.event URL];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - Calendar methods

- (void)promptEditOrRemoveFromCalendar
{
    // TODO: Fix localization
    NSString *deleteTitle = NSLocalizedString(@"Remove from Calendar", nil);
    NSString *editTitle = NSLocalizedString(@"Edit in Calendar", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:deleteTitle otherButtonTitles:editTitle, nil];
    
    [actionSheet showInView:self.view];
}

- (void)presentNewCalendarEvent
{
    EKEvent *calendarEvent = [self newCalendarEvent];
    
	[self presentEventEditorForCalendarEvent:calendarEvent];
}

- (void)presentEditCalendarEvent
{
    EKEvent *calendarEvent = [self.calendarManager.calendarStore eventWithIdentifier:self.event.calendarEventID];
    
    [self presentEventEditorForCalendarEvent:calendarEvent];
}

- (void)presentEventEditorForCalendarEvent:(EKEvent *)calendarEvent
{
    EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.event = calendarEvent;
	eventEditViewController.eventStore = self.calendarManager.calendarStore;
	eventEditViewController.editViewDelegate = self;
    
	[self presentViewController:eventEditViewController animated:YES completion:NULL];
}

- (void)removeFromCalendar
{
    EKEvent *calendarEvent = [self.calendarManager.calendarStore eventWithIdentifier:[self.event calendarEventID]];
    [self removeCalendarEvent:calendarEvent];
}

- (BOOL)isAddedToCalendar
{
    return ([[self.event calendarEventID] length] > 0);
}

- (void)addCalendarEvent:(EKEvent *)calendarEvent
{
    [self.calendarManager.calendarStore saveEvent:calendarEvent span:EKSpanThisEvent error:NULL];
    [self.event setCalendarEventID:calendarEvent.eventIdentifier];
}

- (void)removeCalendarEvent:(EKEvent *)calendarEvent
{
    [self.calendarManager.calendarStore removeEvent:calendarEvent span:EKSpanThisEvent error:NULL];
    [self.event setCalendarEventID:nil];
}

- (EKEvent *)newCalendarEvent
{
    EKEvent *calendarEvent = [self.calendarManager newCalendarEvent];
    calendarEvent.calendar = self.calendarManager.defaultCalendar;
    calendarEvent.title = self.event.title;
    calendarEvent.location = self.event.placeName;
    calendarEvent.startDate = self.event.startAt;
    calendarEvent.endDate = [self.event.startAt dateByAddingTimeInterval:kOneHourOffset];
    
    EKAlarm *alert = self.calendarManager.defaultAlert;
    if (alert != nil) {
        [calendarEvent addAlarm:alert];
    }
    
    return calendarEvent;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if ([self isAddedToCalendar] == YES) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [self removeFromCalendar];
        }
        else {
            [self presentEditCalendarEvent];
        }
    }
}


#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	switch (action) {
		case EKEventEditViewActionCanceled: {
            // Do nothing
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


#pragma mark - RIOExpandableLabelDelegate

- (void)expandableLabelDidLayout:(RIOExpandableLabel *)expandableLabel
{
    self.descriptionHeightConstraint.constant = expandableLabel.displayHeight;
}

- (void)expandableLabelWantsToRevealText:(RIOExpandableLabel *)expandableLabel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.descriptionHeightConstraint.constant = expandableLabel.displayHeight;
        [self.view layoutIfNeeded];
    }];
}



#pragma mark - Private methods

- (void)updateViewInfo
{
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:self.event];
    
    self.titleLabel.text = [self.event title];
    self.locationLabel.text = [self.event placeName];
    self.timeLabel.text = [eventFormatter timeString];
    self.priceLabel.text = [eventFormatter priceString];
    self.categoryImageView.image = [eventFormatter categoryBigImage];
    
    UIImage *posterImage = [self.event imageWithSize:kThumbnailSize];
    if (posterImage != nil) {
        posterImage = [UIImage darkenedAndBlurredImageForImage:posterImage withDarkenScale:0.7 blurRadius:0];
    }
    else {
        posterImage = [UIImage imageNamed:@"MissingPoster"];
    }
    
    self.posterImageView.image = posterImage;
    
    NSString *ageLimit = [NSString stringWithFormat:@"%d+", [self.event ageLimit]];
    self.ageLimitLabel.text = ageLimit;
    
    self.descriptionLabel.text = [eventFormatter currentLocalizedDescription];
    self.descriptionLabel.delegate = self;
    self.descriptionLabel.maxNumberOfLines = 4;
    
    self.favoriteButton.selected = [self.event isFavorite];
    
    // TODO: Fix localization
    NSString *addToCalendar = NSLocalizedString(@"Add to Calendar", nil);
    NSString *removeFromCalendar = NSLocalizedString(@"Remove from Calendar", nil);
    NSString *calendarActionTitle = ([self isAddedToCalendar] == NO) ? addToCalendar : removeFromCalendar;
    
    self.calendarActionLabel.text = calendarActionTitle;
    self.calendarImageView.image = ([self isAddedToCalendar] == NO) ? [UIImage imageNamed:@"Calendar-Normal"] : [UIImage imageNamed:@"Calendar-Selected"];
    
//    if ([self.event URL] == nil) {
//        self.visitWebsiteButton.hidden = YES;
////        [self.view removeConstraint:self.showOnMapConstraint];
////        self.showOnMapConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.showOnMapButton attribute:NSLayoutAttributeTop multiplier:1 constant:20];
////        [self.view addConstraint:self.showOnMapConstraint];
////        [self.view constr]
////        self.showOnMapConstraint
//    }
//    else {
//        self.visitWebsiteButton.hidden = NO;
//    }
}

- (void)setUpStyles
{
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
    self.descriptionLabel.textFont = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
//    self.descriptionLabel.moreButtonText = @"More ▾";
    self.descriptionLabel.moreButtonFont = [UIFont boldSystemFontOfSize:14];
//    self.descriptionLabel.moreButtonFont = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
    self.descriptionLabel.moreButtonColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
}

@end
