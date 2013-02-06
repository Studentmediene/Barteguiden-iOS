//
//  SettingsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Fix code
    if (indexPath.section == 1) {
        [self triggerRefresh:tableView];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - IBAction

- (IBAction)triggerRefresh:(id)sender
{
//    NSLog(@"Refreshing (Not working)");
//    [self.eventStore refresh];
}


@end
