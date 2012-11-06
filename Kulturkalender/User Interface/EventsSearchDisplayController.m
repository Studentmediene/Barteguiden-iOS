//
//  EventsSearchDisplayController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventsSearchDisplayController.h"
#import "EventsSearchDisplayControllerDelegate.h"

@implementation EventsSearchDisplayController {
    NSString *_searchString;
}

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


#pragma mark - UISearchDisplayDelegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // TODO: Optimize code
    _searchString = searchString;
    NSLog(@"%@%@", NSStringFromSelector(_cmd), searchString);
    [self reloadPredicate]; // TODO: Is there something I can do with the implementation of this method?
    return YES;
    //    // Store a copy of the last result in order to check if result has changed
    //    NSArray *lastResult = self.searchDisplayResult;
    //
    //    // Filter search display result
    //    NSString *test = [NSString stringWithFormat:@"*%@*", searchString];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", kResultFriendName, test];
    //    self.searchDisplayResult = [self.sortedResult filteredArrayUsingPredicate:predicate];
    //
    //    // Determine if search display should reload table
    //    if ([self.searchDisplayResult count] != [lastResult count])
    //        return YES;
    //
    //    BOOL hasChanged = !([self.searchDisplayResult isEqualToArray:lastResult]);
    //    return hasChanged;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.fetchedResultsController objectAtIndexPath:[tableView indexPathForSelectedRow]];
    
    [self.delegate navigateTo:item];
}


#pragma mark - AbstractEventsViewController

- (NSPredicate *)predicate
{
    NSPredicate *predicate = [self.delegate predicate];
    
    if ([_searchString length] > 0) {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", _searchString];
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ predicate, searchPredicate ]];
    }
    
    return predicate;
}

@end
