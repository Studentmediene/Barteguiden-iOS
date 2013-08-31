//
//  EventsSearchDisplayController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventsSearchDisplayController.h"
#import "EventsSearchDisplayControllerDelegate.h"
#import "EventKit.h"
#import "EventKitUI.h"


@interface EventsSearchDisplayController ()

@property (nonatomic, strong) NSString *searchString;

@end


@implementation EventsSearchDisplayController

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
    NSLog(@"%@%@", NSStringFromSelector(_cmd), searchString);
    self.searchString = searchString;
    
    [self reloadEventResultsController];
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.eventResultsController eventForIndexPath:indexPath];
    
    [self.delegate navigateToEvent:event];
}


#pragma mark - AbstractEventsViewController

- (NSPredicate *)eventsPredicate
{
    NSPredicate *predicate = [self.delegate eventsPredicate];
    
    if ([self.searchString length] > 0) {
        NSPredicate *titlePredicate = [self.eventStore predicateForTitleContainingText:self.searchString];
        NSPredicate *placeNamePredicate = [self.eventStore predicateForPlaceNameContainingText:self.searchString];
        NSPredicate *searchPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[titlePredicate, placeNamePredicate]];
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, searchPredicate]];
    }
    
    return predicate;
}

- (NSString *)eventsCacheName
{
     // NOTE: Do not cache searches
    return nil;
}

@end
