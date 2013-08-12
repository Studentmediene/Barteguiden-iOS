//
//  SettingsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "SettingsViewController.h"
#import "CalendarManager.h"
#import "AlertChooser.h"


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.defaultCalendarCell) {
        [self navigateToCalendarChooser];
    }
    else if (cell == self.defaultAlertCell) {
        [self navigateToAlertChooser];
    }
    else if (cell == self.sendUsYourTipsCell) {
        [self presentSendUsYourTips];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - IBAction

- (IBAction)toggleAutoAddFavorites:(UISwitch *)sender
{
    [self.calendarManager setAutoAddFavorites:sender.on];
}


#pragma mark - EKCalendarChooserDelegate

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser
{
    self.calendarManager.defaultCalendar = [calendarChooser.selectedCalendars anyObject];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - DefaultAlertViewControllerDelegate

- (void)alertChooserSelectionDidChange:(AlertChooser *)alertChooser
{
    self.calendarManager.defaultAlert = alertChooser.selectedAlert;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Private methods

- (void)updateViewInfo
{
    self.autoAddFavoritesSwitch.on = [self.calendarManager shouldAutoAddFavorites];
    self.defaultCalendarLabel.text = [[self.calendarManager defaultCalendar] title];
//    NSValueTransformer *alertDescription = [NSValueTransformer valueTransformerForName:CalendarAlertDescriptionTransformerName];
//    self.defaultAlertLabel.text = [alertDescription transformedValue:[self.calendarManager defaultAlert]];
    self.defaultAlertLabel.text = [AlertChooser alertDescriptionForAlert:[self.calendarManager defaultAlert]];
}

- (void)navigateToCalendarChooser
{
    __weak typeof(self) bself = self;
    [self.calendarManager requestAccessWithCompletion:^(NSError *error) {
        if (error == nil) {
            EKCalendarChooser *calendarChooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly entityType:EKEntityTypeEvent eventStore:bself.calendarManager.calendarStore];
            calendarChooser.delegate = bself;
            calendarChooser.selectedCalendars = [NSSet setWithObject:[bself.calendarManager defaultCalendar]];
            calendarChooser.title = NSLocalizedStringWithDefaultValue(@"SETTINGS_DEFAULT_CALENDAR_CHOOSER_TITLE", nil, [NSBundle mainBundle], @"Default Calendar", @"Title of default calendar chooser");
            [bself.navigationController pushViewController:calendarChooser animated:YES];
        }
        else {
            NSIndexPath *indexPath = [bself.tableView indexPathForCell:bself.defaultCalendarCell];
            [bself.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }];
}

- (void)navigateToAlertChooser
{
    AlertChooser *alertChooser = [[AlertChooser alloc] init];
    alertChooser.delegate = self;
    alertChooser.selectedAlert = [self.calendarManager defaultAlert];
    alertChooser.title = NSLocalizedStringWithDefaultValue(@"SETTINGS_DEFAULT_ALERT_CHOOSER_TITLE", nil, [NSBundle mainBundle], @"Default Alert", @"Title of default alert chooser");
    [self.navigationController pushViewController:alertChooser animated:YES];
}

- (void)presentSendUsYourTips
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        NSString *subject = NSLocalizedStringWithDefaultValue(@"SETTINGS_SEND_US_YOUR_TIPS_SUBJECT", nil, [NSBundle mainBundle], @"Tips for Barteguiden", @"Subject for email about tips");
        [mailViewController setToRecipients:@[@"barteguiden@gmail.com"]];
        [mailViewController setSubject:subject];
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
    else {
        // TODO: Handle error
    }
}

@end
