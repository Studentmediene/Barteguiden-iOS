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


static NSString * const kHeaderReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
static NSString * const kCellIdentifier = @"EventCell";


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreDidRefresh:) name:EventStoreDidRefreshNotification object:self.eventStore];
    
    [self reloadEventResultsController];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EventStoreDidRefreshNotification object:self.eventStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EventResultsController *)eventResultsController
{
    if (_eventResultsController == nil) {
        _eventResultsController = [[EventResultsController alloc] initWithEventStore:self.eventStore sectionNameBlock:^NSString *(id<Event> event) {
            EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
            NSString *sectionName = [eventFormatter dateSectionName];
            
            return sectionName;
        }];
    }
    
    return _eventResultsController;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [self createCell];
    }
    
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


#pragma mark - EventsSearchDisplayControllerDelegate

- (NSPredicate *)eventsPredicate
{
    NSDate *nowMinus6Hours = [NSDate dateWithTimeIntervalSinceNow:-6*60*60];
    NSPredicate *datePredicate = [self.eventStore predicateForEventsWithStartDate:nowMinus6Hours endDate:[NSDate distantFuture]];
    
    return datePredicate;
}

- (NSString *)eventsCacheName
{
    return nil;
}

- (void)navigateToEvent:(id)event
{
    EventDetailsViewController *eventDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetails"];
    eventDetailsViewController.event = event;
    eventDetailsViewController.calendarManager = self.calendarManager;
    
    [self.navigationController pushViewController:eventDetailsViewController animated:YES];
}


#pragma mark - Notifications

- (void)eventStoreDidRefresh:(NSNotification *)note
{
    [self reloadEventResultsController];
    [self.tableView reloadData];
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

- (void)reloadEventResultsController
{
    NSLog(@"Reloading EventResultsController");
    [self.eventResultsController performFetchWithPredicate:[self eventsPredicate] cacheName:[self eventsCacheName] error:NULL]; // TODO: Add error handling
}

- (UITableViewCell *)createCell
{
//    NSLog(@"Generating new cell from nib");
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
    return (UITableViewCell *)[nib objectAtIndex:0];
}

@end
