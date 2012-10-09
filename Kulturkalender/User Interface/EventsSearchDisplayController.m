//
//  EventsSearchDisplayController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventsSearchDisplayController.h"
#import "EventsSearchDisplayControllerDelegate.h"

@implementation EventsSearchDisplayController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return [[self.delegate result] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchDisplayTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
//    NSDictionary *friend = (self.searchDisplayResult)[indexPath.row];
//    cell.textLabel.text = friend[kResultFriendName];
    cell.textLabel.text = @"Tirsdagskviss";
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Convert index path from search display result to sorted result
//    id object = (self.searchDisplayResult)[indexPath.row];
//    NSUInteger row = [self.sortedResult indexOfObject:object];
//    NSIndexPath *sortedResultIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    
//    // Select row in table view and perform segue
//    [self.friendsViewController.tableView selectRowAtIndexPath:sortedResultIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self.friendsViewController performSegueWithIdentifier:@"FilteredHistorySegue" sender:self];
    
    NSLog(@"Selected row");
}


#pragma mark - UISearchDisplayDelegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
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

@end
