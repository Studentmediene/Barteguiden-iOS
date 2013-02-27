//
//  AbstractEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"
#import "EventKit.h"
#import "EventKitUI.h"

#import "EventDetailsViewController.h"
#import "EventCell.h"


@implementation AbstractEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventResultsController = [[EventResultsController alloc] initWithEventStore:self.eventStore sectionNameBlock:^NSString *(id<Event> event) {
        EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
        NSString *sectionName = [eventFormatter dateSectionName];
        
        return sectionName;
    }];
    self.eventResultsController.delegate = self;
    NSSortDescriptor *startAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startAt" ascending:YES];
    self.eventResultsController.sortDescriptors = @[startAtSortDescriptor];
    
    // Hide search bar as default
    self.tableView.contentOffset = CGPointMake(0, -44);//self.searchDisplayController.searchBar.frame.size.height);
//    self.tableView.contentInset = UIEdgeInsetsMake(-44,0,0,0);
    
    [self reloadPredicate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.eventResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<EventResultsSectionInfo> sectionInfo = self.eventResultsController.sections[section];
    return [sectionInfo numberOfEvents];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cell];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<EventResultsSectionInfo> sectionInfo = self.eventResultsController.sections[section];
    return [sectionInfo name];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.eventResultsController eventForIndexPath:indexPath];
    
    [self navigateToEvent:event];
}

#pragma mark - EventResultsControllerDelegate

- (void)eventResultsControllerWillChangeContent:(EventResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)eventResultsController:(EventResultsController *)controller didChangeSection:(id<EventResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(EventResultsChangeType)type
{
    switch (type)
    {
        case EventResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case EventResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

- (void)eventResultsController:(EventResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(EventResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case EventResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case EventResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case EventResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case EventResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)eventResultsControllerDidChangeContent:(EventResultsController *)controller
{
    [self.tableView endUpdates];
}

//- (void)eventResultsControllerDidChangeContent:(EventResultsController *)controller
//{
//    [self.tableView reloadData];
//}


#pragma mark - EventsSearchDisplayControllerDelegate

- (NSPredicate *)eventsPredicate
{
    // Date predicate
    // TODO: Fix this predicate
    NSDate *now = [NSDate date];
    NSString *format = @"(endAt != nil AND endAt >= %@) OR startAt >= %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, now, now];
    
    return predicate;
}

- (void)navigateToEvent:(id)event
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Kulturkalender" bundle:nil];
    EventDetailsViewController *eventDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EventDetails"];
//    eventDetailsViewController.delegate = self;
    eventDetailsViewController.event = event;
    
    [self.navigationController pushViewController:eventDetailsViewController animated:YES];
}


#pragma mark - Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.eventResultsController eventForIndexPath:indexPath];
    
    EventCell *eventCell = (EventCell *)cell;
    
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
    UIImage *image = [event imageWithSize:CGSizeMake(0, 0)] ?: [UIImage imageNamed:@"EmptyPoster"];
    eventCell.thumbnailImageView.image = image;
    eventCell.titleLabel.text = [event title];
    eventCell.detailLabel.text = [eventFormatter timeAndLocationString];
    eventCell.priceLabel.text = [eventFormatter priceString];
}

- (void)reloadPredicate
{
    self.eventResultsController.predicate = [self eventsPredicate];
    [self.eventResultsController performFetch:NULL];
    [self.tableView reloadData];
}

- (UITableViewCell *)cell
{
    static NSString *cellIdentifier = @"EventCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSLog(@"Generating new cell from nib");
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
        [cell prepareForReuse];
    }

    return cell;
}

@end
 