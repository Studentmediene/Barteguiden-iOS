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

#import "NSArray+RIOClassifier.h"


@implementation AbstractEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide search bar as default
//    self.tableView.conten
    self.tableView.contentOffset = CGPointMake(0, -44);//self.searchDisplayController.searchBar.frame.size.height);
//    self.tableView.contentInset = UIEdgeInsetsMake(-44,0,0,0);
    
    [self reloadPredicate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // TODO: Fix
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:EventStoreDidRefreshNotification];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // TODO: Fix
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.result count]; // TODO: Fix
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cell];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"DAY"; // TODO: Fix
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Event> event = [self.result objectAtIndex:indexPath.row]; // TODO: Fix
    
    [self navigateToEvent:event];
}


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
    id<Event> event = [self.result objectAtIndex:indexPath.row]; // TODO: Fix
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
    
    EventCell *eventCell = (EventCell *)cell;
    
//    NSString *imageName = event.imageID ?: @"EmptyPoster";
//    eventCell.thumbnailImageView.image = [UIImage imageNamed:imageName];
    eventCell.titleLabel.text = [event title];
    eventCell.detailLabel.text = [eventFormatter timeAndLocationString];
    eventCell.priceLabel.text = [eventFormatter priceString];
}

- (void)reloadPredicate
{
    self.result = [self.eventStore eventsMatchingPredicate:[self eventsPredicate]];
    
    // TODO: How to sort the sections?
    NSDictionary *dict = [self.result classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:obj];
        return [eventFormatter dateSectionName];
    }];
    NSLog(@"%@", dict);
    
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
 