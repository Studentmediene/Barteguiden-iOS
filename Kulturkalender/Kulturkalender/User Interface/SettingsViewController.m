//
//  SettingsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarStore = [[EKEventStore alloc] init]; // TODO: Inject instead?
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
        EKCalendarChooser *calendarChooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly entityType:EKEntityTypeEvent eventStore:self.calendarStore];
        calendarChooser.selectedCalendars = [NSSet setWithObject:[self.calendarStore defaultCalendarForNewEvents]];
        calendarChooser.title = NSLocalizedString(@"Default Calendar", nil);
        [self.navigationController pushViewController:calendarChooser animated:YES];
    }
    else if (cell == self.defaultAlertCell) {
        
    }
    else if (cell == self.sendUsYourTipsCell) {
        [self sendUsYourTips:cell];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

- (IBAction)sendUsYourTips:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        // FIXME: Update these values
        [mailViewController setToRecipients:@[@"tips@underdusken.no"]];
        [mailViewController setSubject:@"Subject Goes Here."];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
        
    }
    else {
        // TODO: Handle error
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
