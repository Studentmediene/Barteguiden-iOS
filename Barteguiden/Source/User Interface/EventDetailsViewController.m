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

#import "WebsiteViewController.h"
#import "MapViewController.h"


static NSString * const kWebsiteSegue = @"WebsiteSegue";
static NSString * const kMapSegue = @"MapSegue";

static NSUInteger const kActionsSection = 0;
static NSUInteger const kLinksSection = 1;

static NSUInteger const kWebsiteRow = 0;
static NSUInteger const kMapRow = 1;

static CGFloat const kDescriptionLabelBottomMargin = 5;

static CGSize const kThumbnailSize = {320, 200};
static float const kOneHourOffset = 1*60*60;


@interface EventDetailsViewController ()

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UILabel *descriptionTitleLabel;
@property (nonatomic, strong) RIOExpandableLabel *descriptionLabel;

@end


@implementation EventDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpConstraints];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareEvent:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarStoreChanged:) name:EKEventStoreChangedNotification object:self.calendarManager.calendarStore];
    
    // WORKAROUND: Let the descriptionView be updated first
    [self.tableView reloadData];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kActionsSection) {
        return 1;
    }
    else {
        NSUInteger websiteCount = ([self.event URL] != nil) ? 1 : 0;
        NSUInteger mapCount = ([self.event hasLocation] == YES) ? 1 : 0;
        
        return websiteCount + mapCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kActionsSection) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section] == 2) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSUInteger row = ([self.event URL] != nil) ? kWebsiteRow : kMapRow;
    NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    
    return [super tableView:tableView cellForRowAtIndexPath:adjustedIndexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kActionsSection) {
        return self.descriptionView;
    }
    
    return [super tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kActionsSection) {
        return CGRectGetMaxY(self.descriptionLabel.frame) + kDescriptionLabelBottomMargin;
    }
    
    return [super tableView:tableView heightForFooterInSection:section];
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

- (IBAction)revealDescription:(id)sender
{
    [self.tableView beginUpdates];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.descriptionLabel.maxNumberOfLines = 0;
        [self.view layoutIfNeeded];
    }];
    
    [self.tableView endUpdates];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:kWebsiteSegue]){
        WebsiteViewController *websiteViewController = (WebsiteViewController *)[segue destinationViewController];
        websiteViewController.openURL = [self.event URL];
    }
    else if ([[segue identifier] isEqualToString:kMapSegue]) {
        MapViewController *mapViewController = (MapViewController *)[segue destinationViewController];
        mapViewController.annotation = [[EventAnnotation alloc] initWithEvent:self.event];
    }
}


#pragma mark - Calendar methods

- (void)promptEditOrRemoveFromCalendar
{
    NSString *deleteTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_DELETE_BUTTON", nil, [NSBundle mainBundle], @"Remove from Calendar", @"Title of delete button in action sheet (Displayed when toggling calendar button)");
    NSString *editTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_EDIT_BUTTON", nil, [NSBundle mainBundle], @"Edit in Calendar", @"Title of edit button in action sheet (Displayed when toggling calendar button)");
    NSString *cancelTitle = NSLocalizedStringWithDefaultValue(@"TOGGLE_CALENDAR_ACTION_SHEET_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"Cancel", @"Title of cancel button in action sheet (Displayed when toggling calendar button)");
    
    PSPDFActionSheet *calendarActionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    [calendarActionSheet setDestructiveButtonWithTitle:deleteTitle block:^(NSInteger a){
        [self removeFromCalendar];
    }];
    [calendarActionSheet addButtonWithTitle:editTitle block:^(NSInteger a){
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
    
    NSString *priceFormat = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_PRICE_FORMAT", nil, [NSBundle mainBundle], @"From %1$@", @"Format of price in event details");
    NSString *priceText = [NSString localizedStringWithFormat:priceFormat, [eventFormatter priceString]];
    
    self.titleLabel.text = [self.event title];
    self.locationLabel.text = [self.event placeName];
    self.priceLabel.text = priceText;
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
    _descriptionLabel.text = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.favoriteButton.selected = [self.event isFavorite];
    self.calendarButton.selected = [self isAddedToCalendar];
     
    [self.calendarButton setTitle:[eventFormatter timeString] forState:UIControlStateNormal];
}

- (void)setUpConstraints
{
    [self.ageLimitBorderView removeConstraint:self.ageLimitBorderWidthConstraint];
    [self.ageLimitBorderView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.ageLimitBorderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.ageLimitLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:10]];
}

- (UIView *)descriptionView
{
    if (_descriptionView == nil) {
        _descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        
        UILabel *descriptionTitleLabel = self.descriptionTitleLabel;
        RIOExpandableLabel *descriptionLabel = self.descriptionLabel;
        
        [_descriptionView addSubview:descriptionTitleLabel];
        [_descriptionView addSubview:descriptionLabel];
        
        [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[descriptionTitleLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(descriptionTitleLabel)]];
        [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[descriptionLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(descriptionLabel)]];
        [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[descriptionTitleLabel]-3-[descriptionLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(descriptionTitleLabel, descriptionLabel)]];
    }
    
    return _descriptionView;
}

- (UILabel *)descriptionTitleLabel
{
    if (_descriptionTitleLabel == nil) {
        _descriptionTitleLabel = [[UILabel alloc] init];
        _descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _descriptionTitleLabel.text = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_DESCRIPTION_TITLE", nil, [NSBundle mainBundle], @"Description", @"Title of description in event details");
    }
    
    return _descriptionTitleLabel;
}

- (RIOExpandableLabel *)descriptionLabel
{
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[RIOExpandableLabel alloc] init];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.textFont = [UIFont systemFontOfSize:15];
        _descriptionLabel.maxNumberOfLines = 4;
        _descriptionLabel.moreButtonColor = self.view.tintColor;
        _descriptionLabel.moreButtonFont = [UIFont systemFontOfSize:15];
        _descriptionLabel.moreButtonText = NSLocalizedStringWithDefaultValue(@"EVENT_DETAILS_MORE_BUTTON_TEXT", nil, [NSBundle mainBundle], @"More ▼", @"Text of more button in event details");
        [_descriptionLabel moreButtonAddTarget:self action:@selector(revealDescription:)];
    }
    
    return _descriptionLabel;
}

@end
