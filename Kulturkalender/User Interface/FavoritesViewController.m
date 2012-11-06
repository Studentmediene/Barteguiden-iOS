//
//  FavoritedEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FavoritesViewController.h"
#import "EventManager.h"

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Enable editing of favorites
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AbstractEventsViewController

- (NSPredicate *)eventsPredicate
{
    // NOTE: Does not call [super eventsPredicate] to allow old events to show in this list
    
    NSPredicate *favoritesPredicate = [NSPredicate predicateWithFormat:@"favorite == 1"];
    
    return favoritesPredicate;
}

- (NSString *)cacheName
{
    return @"FavoritesCache";
}


#pragma mark - UITableViewDataSource

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Remove favorite flag
        Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        event.favorite = @NO;
    }
}


#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Unstar"; // TODO: Remember to localize
}

@end
