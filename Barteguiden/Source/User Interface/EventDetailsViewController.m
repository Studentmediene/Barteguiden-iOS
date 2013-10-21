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
#import <PSPDFActionSheet.h>
#import "NavigationButton.h"

#import "WebsiteViewController.h"
#import "MapViewController.h"


static NSString * const kWebsiteSegue = @"WebsiteSegue";
static NSString * const kMapSegue = @"MapSegue";

static CGSize const kGroupedTableViewButtonSize = {280, 44};
static CGSize const kThumbnailSize = {320, 200};
static float const kOneHourOffset = 1*60*60;


@interface EventDetailsViewController ()

@property (nonatomic, strong) UIButton *visitWebsiteButton;
@property (nonatomic, strong) UIButton *showOnMapButton;

@end


@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpStyles];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareEvent:)];
    
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


#pragma mark - IBAction

- (IBAction)shareEvent:(id)sender
{
    NSString *shareTextFormat = NSLocalizedStringWithDefaultValue(@"SHARE_TEXT_FORMAT", nil, [NSBundle mainBundle], @"Join me at %1$@!", @"Message to share with friends [1. Title of event]");
    NSString *shareWithURLTextFormat = NSLocalizedStringWithDefaultValue(@"SHARE_TEXT_WITH_URL_FORMAT", nil, [NSBundle mainBundle], @"Join me at %1$@! (%2$@)", @"Message to share with friends [1. Title of event, 2. URL for event]");
    
    NSString *shareText;
    if (self.event.URL != nil) {
        shareText = [NSString stringWithFormat:shareWithURLTextFormat, self.event.title, self.event.URL];
    }
    else {
        shareText = [NSString stringWithFormat:shareTextFormat, self.event.title];
    }
    
    NSArray *activityItems = @[shareText];
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
        [self.calendarManager requestAccessWithCompletion:^(NSError *error) {
            if (error == nil) {
                if (newFavorite == YES && [self isAddedToCalendar] == NO) {
                    EKEvent *calendarEvent = [self newCalendarEvent];
                    [self addCalendarEvent:calendarEvent];
                }
                else if (newFavorite == NO && [self isAddedToCalendar] == YES) {
                    EKEvent *calendarEvent = [self.calendarManager.calendarStore eventWithIdentifier:self.event.calendarEventID];
                    [self removeCalendarEvent:calendarEvent];
                }
            }
        }];
    }
}

- (IBAction)toggleCalendarEvent:(id)sender
{
    [self.calendarManager requestAccessWithCompletion:^(NSError *error) {
        if (error == nil) {
            if ([self isAddedToCalendar] == NO) {
                [self presentNewCalendarEvent];
            }
            else {
                [self promptEditOrRemoveFromCalendar];
            }
        }
    }];
}

- (IBAction)visitWebsite:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    WebsiteViewController *websiteViewController = [storyboard instantiateViewControllerWithIdentifier:@"Website"];
    websiteViewController.openURL = [self.event URL];
    [self.navigationController pushViewController:websiteViewController animated:YES];
}

- (IBAction)showOnMap:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"Map"];
    mapViewController.annotation = [[EventAnnotation alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)revealDescription:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.descriptionLabel.maxNumberOfLines = 0;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Calendar methods

- (void)promptEditOrRemoveFromCalendar
{
    NSString *deleteTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_DELETE_BUTTON", nil, [NSBundle mainBundle], @"Remove from Calendar", @"Title of delete button in action sheet (Displayed when toggling calendar button)");
    NSString *editTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_EDIT_BUTTON", nil, [NSBundle mainBundle], @"Edit in Calendar", @"Title of edit button in action sheet (Displayed when toggling calendar button)");
    NSString *cancelTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"Cancel", @"Title of cancel button in action sheet (Displayed when toggling calendar button)");
    
    PSPDFActionSheet *calendarActionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    [calendarActionSheet setDestructiveButtonWithTitle:deleteTitle block:^{
        [self removeFromCalendar];
    }];
    [calendarActionSheet addButtonWithTitle:editTitle block:^{
        [self presentEditCalendarEvent];
    }];
    [calendarActionSheet setCancelButtonWithTitle:cancelTitle block:NULL];
    [calendarActionSheet showWithSender:nil fallbackView:self.view animated:YES];
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
    [self.calendarManager.calendarStore saveEvent:calendarEvent span:EKSpanThisEvent error:NULL]; // TODO: Add error handling
    [self.event setCalendarEventID:calendarEvent.eventIdentifier];
}

- (void)removeCalendarEvent:(EKEvent *)calendarEvent
{
    [self.calendarManager.calendarStore removeEvent:calendarEvent span:EKSpanThisEvent error:NULL]; // TODO: Add error handling
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
    
    NSString *ageLimit = [NSString stringWithFormat:@"%@+", [self.event ageLimit]];
    self.ageLimitLabel.text = ageLimit;
    
    NSString *defaultDescription = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_NO_DESCRIPTION", nil, [NSBundle mainBundle], @"No description", @"Default text if there are no description of event");
    NSString *description = [eventFormatter currentLocalizedDescription] ?: defaultDescription;
    self.descriptionLabel.text = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.descriptionLabel.maxNumberOfLines = 4;
    [self.descriptionLabel moreButtonAddTarget:self action:@selector(revealDescription:)];
    
    self.favoriteButton.selected = [self.event isFavorite];
    
    // Set up toggle calendar button
    NSString *addToCalendar = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_ADD_TO_CALENDAR_LABEL", nil, [NSBundle mainBundle], @"Add to Calendar", @"Text inside toggle calendar button in event details");
    NSString *removeFromCalendar = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_REMOVE_FROM_CALENDAR_LABEL", nil, [NSBundle mainBundle], @"Remove from Calendar", @"Text inside toggle calendar button in event details");
    NSString *calendarActionTitle = ([self isAddedToCalendar] == NO) ? addToCalendar : removeFromCalendar;
    
    self.calendarActionLabel.text = calendarActionTitle;
    self.calendarImageView.image = ([self isAddedToCalendar] == NO) ? [UIImage imageNamed:@"Calendar-Normal"] : [UIImage imageNamed:@"Calendar-Selected"];
    
    // Set up 'visit website' and 'show on map' buttons
    [self updateBottomMostView:self.descriptionLabel];
    
    if ([self.event URL] != nil) {
        UIButton *visitWebsiteButton = [self visitWebsiteButton];
        [self.scrollView addSubview:visitWebsiteButton];
        
        NSArray *buttonConstraints = [self constraintsForButton:visitWebsiteButton withTopSpacing:20];
        [self.scrollView addConstraints:buttonConstraints];
        
        [self updateBottomMostView:visitWebsiteButton];
    }
    else {
        [[self visitWebsiteButton] removeFromSuperview];
    }
    
    if ([self.event hasLocation]) {
        UIButton *showOnMapButton = [self showOnMapButton];
        [self.scrollView addSubview:showOnMapButton];
        
        CGFloat topSpacing = (self.bottomMostView == self.visitWebsiteButton) ? 10 : 20;
        NSArray *buttonConstraints = [self constraintsForButton:showOnMapButton withTopSpacing:topSpacing];
        [self.scrollView addConstraints:buttonConstraints];
        
        [self updateBottomMostView:showOnMapButton];
    }
    else {
        [[self showOnMapButton] removeFromSuperview];
    }
}

- (void)setUpStyles
{
    UIImage *highlightedToggleCalendarButtonImage = [UIImage imageNamed:@"TextHighlight"];
    [self.calendarButton setBackgroundImage:highlightedToggleCalendarButtonImage forState:UIControlStateHighlighted];
    
// TODO: Use this code to make a border around age limit
//    self.priceLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.priceLabel.layer.borderWidth = 2;
//    self.priceLabel.layer.cornerRadius = 2;
    
//    self.descriptionLabel.moreButtonText = @"More ▾";
//    self.descriptionLabel.moreButtonFont = [UIFont boldSystemFontOfSize:14];
    self.descriptionLabel.textFont = [UIFont systemFontOfSize:15];
    self.descriptionLabel.moreButtonFont = [UIFont boldSystemFontOfSize:15];
    self.descriptionLabel.moreButtonColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
}

- (UIButton *)visitWebsiteButton
{
    if (_visitWebsiteButton == nil) {
        NSString *title = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_VISIT_WEBSITE_BUTTON", nil, [NSBundle mainBundle], @"Visit Website", @"Title of button to visit the event's website");
        _visitWebsiteButton = [[NavigationButton alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        [_visitWebsiteButton setImage:[UIImage imageNamed:@"Website-Normal"] forState:UIControlStateNormal];
        [_visitWebsiteButton setImage:[UIImage imageNamed:@"Website-Highlighted"] forState:UIControlStateHighlighted];
        [_visitWebsiteButton setTitle:title forState:UIControlStateNormal];
        [_visitWebsiteButton addTarget:self action:@selector(visitWebsite:) forControlEvents:UIControlEventTouchUpInside];
        [_visitWebsiteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setStylesForButton:_visitWebsiteButton];
    }
    
    return _visitWebsiteButton;
}

- (UIButton *)showOnMapButton
{
    if (_showOnMapButton == nil) {
        NSString *title = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_SHOW_ON_MAP_BUTTON", nil, [NSBundle mainBundle], @"Show on Map", @"Title of button to show location on map");
        _showOnMapButton = [[NavigationButton alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        [_showOnMapButton setImage:[UIImage imageNamed:@"Location-Normal"] forState:UIControlStateNormal];
        [_showOnMapButton setImage:[UIImage imageNamed:@"Location-Highlighted"] forState:UIControlStateHighlighted];
        [_showOnMapButton setTitle:title forState:UIControlStateNormal];
        [_showOnMapButton addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
        [_showOnMapButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setStylesForButton:_showOnMapButton];
    }
    
    return _showOnMapButton;
}

- (NSArray *)constraintsForButton:(UIButton *)button withTopSpacing:(CGFloat)topSpacing
{
    UIView *bottomMostView = self.bottomMostView;
    
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[button]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    NSArray *buttonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomMostView]-topSpacing-[button]" options:0 metrics:@{@"topSpacing": @(topSpacing)} views:NSDictionaryOfVariableBindings(bottomMostView, button)];
    
    return [buttonHorizontalConstraints arrayByAddingObjectsFromArray:buttonVerticalConstraints];
}

- (void)updateBottomMostView:(UIView *)newBottomMostView
{
    [self.scrollView removeConstraint:self.bottomMostViewSpacingConstraint];
    
    self.bottomMostView = newBottomMostView;
    self.bottomMostViewSpacingConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomMostView attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    
    [self.scrollView addConstraint:self.bottomMostViewSpacingConstraint];
}

- (void)setStylesForButton:(UIButton *)button
{
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    UIColor *textColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
    [button setTitleColor:textColor forState:UIControlStateNormal];
}

@end
