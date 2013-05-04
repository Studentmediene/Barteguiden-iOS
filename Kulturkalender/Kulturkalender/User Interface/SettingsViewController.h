//
//  SettingsViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MessageUI/MessageUI.h>

@protocol CalendarManager;


@interface SettingsViewController : UITableViewController <EKCalendarChooserDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableViewCell *defaultCalendarCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *defaultAlertCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *sendUsYourTipsCell;
@property (nonatomic, weak) IBOutlet UISwitch *autoAddFavoritesSwitch;
@property (nonatomic, weak) IBOutlet UILabel *defaultCalendarLabel;
@property (nonatomic, weak) IBOutlet UILabel *defaultAlertLabel;

@property (nonatomic, strong) id<CalendarManager> calendarManager;

- (IBAction)toggleAutoAddFavorites:(id)sender;

@end
