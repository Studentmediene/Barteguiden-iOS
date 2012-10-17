//
//  AbstractEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"
#import "EventManager.h"
#import "EventDetailsViewController.h"

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
    
    // Add refresh control and observe
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(triggerRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:EventManagerDidRefreshNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Refresh complete");
        [refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:EventManagerDidRefreshNotification];
}


#pragma mark - Abstract methods

- (NSPredicate *)tabPredicate
{
    return nil;
}

- (NSString *)cacheName
{
    return nil;
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"EventDetailsSegue"]) {
        Event *event = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
//        eventDetailsViewController.delegate = self;
        eventDetailsViewController.event = event;
    }
}


#pragma mark - UITableViewDataSource

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


#pragma mark - UITableViewDelegate

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


#pragma mark - NSFetchedResultsController

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


#pragma mark - EventsSearchDisplayControllerDelegate

- (NSArray *)result
{
    return @[ @"abc", @"def" ];
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
    
    // Set date formatter
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *detail = [NSString stringWithFormat:@"%@ at %@", [dateFormatter stringFromDate:event.timeStartAt], event.location.placeName]; // TODO: Localize
    
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = detail;
}

- (void)setUpFetchedResultsController
{
    // Set up the fetch request
    NSManagedObjectContext *managedObjectContext = [[EventManager sharedManager] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity.name];
    fetchRequest.includesSubentities = YES;
    fetchRequest.fetchBatchSize = 20;
    
    // Set predicate
    [fetchRequest setPredicate:[self predicate]];
    
    // Set sort descriptor
    NSSortDescriptor *timeStartAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStartAt" ascending:YES];
    NSArray *sortDescriptors = @[ timeStartAtSortDescriptor ];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Set a default cache name
    NSString *cacheName = nil;
//    NSString *cacheName = [self cacheName];
    // TODO: Fix cache name
    
    // Create the fetched results controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:kEventSectionName cacheName:cacheName];
    self.fetchedResultsController.delegate = self;
}

- (NSPredicate *)predicate
{
    NSPredicate *tabPredicate = [self tabPredicate];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"timeEndAt >= %@", [NSDate date]];
    
    NSPredicate *predicate;
    if (tabPredicate != nil) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ tabPredicate, datePredicate ]];
    }
    else {
        predicate = datePredicate;
    }
    
    return predicate;
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
}

- (void)triggerRefresh
{
    [[EventManager sharedManager] refresh];
}

@end
 