//
//  SettingsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableViewCell *tipsUsCell;

@end
