//
//  SettingsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "SettingsViewController.h"
#import "CalendarManager.h"
#import "DefaultAlertViewController.h"


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
        EKCalendarChooser *calendarChooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly entityType:EKEntityTypeEvent eventStore:self.calendarManager.calendarStore];
        calendarChooser.delegate = self;
        calendarChooser.selectedCalendars = [NSSet setWithObject:[self.calendarManager defaultCalendar]];
        calendarChooser.title = NSLocalizedString(@"Default Calendar", nil);
        [self.navigationController pushViewController:calendarChooser animated:YES];
    }
    else if (cell == self.sendUsYourTipsCell) {
        [self sendUsYourTips:cell];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

- (IBAction)toggleAutoAddFavorites:(UISwitch *)sender
{
    [self.calendarManager setAutoAddFavorites:sender.on];
}

- (IBAction)sendUsYourTips:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        // FIXME: Update these values
        [mailViewController setToRecipients:@[@"tips@underdusken.no"]];
        [mailViewController setSubject:@""];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
        
    }
    else {
        // TODO: Handle error
    }
}


#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isEqual:@"DefaultAlertSegue"]) {
        DefaultAlertViewController *defaultAlertViewController = [segue destinationViewController];
        defaultAlertViewController.selectedTimeInterval = [[self.calendarManager defaultAlert] relativeOffset];
    }
}

#pragma mark - EKCalendarChooserDelegate

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser
{
    EKCalendar *selectedCalendar = [calendarChooser.selectedCalendars anyObject];
    [self.calendarManager setDefaultCalendar:selectedCalendar];
}


#pragma mark - DefaultAlertViewControllerDelegate

- (void)defaultAlertViewController:(DefaultAlertViewController *)defaultAlertViewController didSelectAlert:(EKAlarm *)alert
{
    
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
    self.defaultAlertLabel.text = [NSString stringWithFormat:@"%.0f", [[self.calendarManager defaultAlert] relativeOffset]];
}

@end
