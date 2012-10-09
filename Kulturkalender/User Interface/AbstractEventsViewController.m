//
//  EventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"
#import "EventManager.h"

@implementation AbstractEventsViewController

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Add refresh control and observe
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:EventManagedDidRefresh object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Notif");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:EventManagedDidRefresh];
}


#pragma mark - Abstract methods

- (NSPredicate *)predicate
{
    return nil;
}

- (NSString *)cacheName
{
    return nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EventTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        [self setUpFetchedResultsController];
        [self performFetch];
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    id<FLLoan> loan = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    UIImage *lentImage = [UIImage imageNamed:@"UpArrow-Normal"];
//    UIImage *lentHighlightedImage = [UIImage imageNamed:@"UpArrow-Highlighted"];
//    UIImage *borrowedImage = [UIImage imageNamed:@"DownArrow-Normal"];
//    UIImage *borrowedHighlightedImage = [UIImage imageNamed:@"DownArrow-Highlighted"];
//    //    UIImage *image = [loan categoryImage];
//    //    UIImage *highlightedImage = [loan categoryHighlightedImage];
//    
//    // FIXME: Fix code
//    NSString *amountText = @"FIXME";//loan.amountPresentation;
//    NSString *friendText = @"FIXME";//loan.friendFullName;
//    
//    BOOL settled = [loan isSettled];
//    BOOL lent = NO;//[loan.lent boolValue];
//    
//    UIImage *image = (lent == YES) ? lentImage : borrowedImage;
//    UIImage *highlightedImage = (lent == YES) ? lentHighlightedImage : borrowedHighlightedImage;
//    
//    NSString *format = nil;
//    if (settled == NO) {
//        if (lent == YES) {
//            format = NSLocalizedString(@"Lent %1$@ to %2$@", @"Outgoing loans in History-tab");
//        }
//        else {
//            format = NSLocalizedString(@"Borrowed %1$@ from %2$@", @"Incoming loans in History-tab");
//        }
//    }
//    else {
//        if (lent == YES) {
//            format = NSLocalizedString(@"Paid back %1$@ to %2$@", @"Settled incoming loans in History-tab");
//        }
//        else {
//            format = NSLocalizedString(@"Got back %1$@ from %2$@", @"Settled outgoing loans in History-tab");
//        }
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:format, amountText, friendText];
//    cell.imageView.image = image;
//    cell.imageView.highlightedImage = highlightedImage;
    
    NSManagedObject *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [event valueForKey:@"title"];
    cell.detailTextLabel.text = [event valueForKey:@"note"];
}

- (void)setUpFetchedResultsController
{
    // Set up the fetch request
    NSManagedObjectContext *managedObjectContext = [[EventManager sharedManager] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity.name];
    fetchRequest.includesSubentities = YES;
    fetchRequest.fetchBatchSize = 20;
    
    [fetchRequest setPredicate:[self predicate]];
    
    // Add sort descriptor
//    NSSortDescriptor *createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
//    NSArray *sortDescriptors = @[ createdAtSortDescriptor ];
    NSArray *sortDescriptors = @[ ];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // TODO: 
    
    // Set a default cache name
//    NSString *cacheName = [self cacheName];
    
    // Filter the history based on friend ID
//    if (self.friendID != nil)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendID == %@", self.friendID];
//        [fetchRequest setPredicate:predicate];
//        
//        // Use a specific cache name
//        cacheName = [NSString stringWithFormat:@"FriendID%@Cache", self.friendID];
//    }
    
    // Create the fetched results controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil]; // TODO: Fix section name and cache key
    self.fetchedResultsController.delegate = self;
}

- (void)reloadPredicate
{
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
    [self.fetchedResultsController.fetchRequest setPredicate:[self predicate]];
    [self performFetch];
    [self.tableView reloadData];
}

- (void)performFetch
{
    // Remove cache if date has changed
//    static NSDate *lastFetchDate = nil;
//    if (lastFetchDate == nil || ![lastFetchDate isEqualToDateIgnoringTime:[NSDate date]]) {
//        [NSFetchedResultsController deleteCacheWithName:@"HistoryCache"];
//    }
    
    // Perform fetch and handle error
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    // Save last fetch date
//    lastFetchDate = [NSDate date];
}

- (void)refresh
{
    [[EventManager sharedManager] refresh];
    NSLog(@"Should refresh");
    [self.refreshControl endRefreshing];
}

@end
 