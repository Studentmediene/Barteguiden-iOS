//
//  AbstractEventsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 26.09.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"
#import "EventKit.h"
#import "EventKitUI.h"
#import "CalendarManager.h"

#import "EventDetailsViewController.h"
#import "EventCell.h"

#import "HeaderView.h"


static NSString *kHeaderReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";


@implementation AbstractEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide search bar as default
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    self.tableView.separatorColor = [UIColor colorWithHue:(216/360.0) saturation:(5/100.0) brightness:(83/100.0) alpha:1];
    
    [self.tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Setting delegate to:%@", self);
    self.eventResultsController.delegate = self;
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
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.eventResultsController eventForIndexPath:indexPath];
    
    [self navigateToEvent:event];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23; // TODO: Why 23 and not 24?
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderReuseIdentifier];
    
    return sectionHeaderView;
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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


#pragma mark - EventsSearchDisplayControllerDelegate

- (NSPredicate *)eventsPredicate
{
    NSPredicate *datePredicate = [self.eventStore predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate distantFuture]];
    
    return datePredicate;
}

- (void)navigateToEvent:(id)event
{
    EventDetailsViewController *eventDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetails"];
//    eventDetailsViewController.delegate = self;
    eventDetailsViewController.event = event;
    eventDetailsViewController.calendarManager = self.calendarManager;
    
    [self.navigationController pushViewController:eventDetailsViewController animated:YES];
}


#pragma mark - Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.eventResultsController eventForIndexPath:indexPath];
    
    EventCell *eventCell = (EventCell *)cell;
    
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
    eventCell.titleLabel.text = [event title];
    eventCell.subtitleLabel.text = [eventFormatter timeAndLocationString];
    eventCell.detailLabel.text = [eventFormatter priceString];
    eventCell.thumbnailImageView.image = [eventFormatter categoryImage];
}

- (void)reloadPredicate
{
    NSLog(@"Reloading predicate");
    self.eventResultsController.predicate = [self eventsPredicate];
    [self.eventResultsController performFetch:NULL];
    [self.tableView reloadData];
}

- (UITableViewCell *)cell
{
    static NSString *cellIdentifier = @"EventCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
//        NSLog(@"Generating new cell from nib"); // TODO: Use this to check that search field works
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
        [cell prepareForReuse];
    }

    return cell;
}

@end
 