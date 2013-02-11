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

#import "NSArray+RIOClassifier.h" // TODO: Temp?


@implementation AbstractEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide search bar as default
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
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [self.sections objectAtIndex:section];
    NSArray *events = [self.items objectForKey:sectionName];
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cell];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    id<Event> event = [[self.items objectForKey:sectionName] objectAtIndex:indexPath.row];
    
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
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    id<Event> event = [[self.items objectForKey:sectionName] objectAtIndex:indexPath.row];
    
    EventCell *eventCell = (EventCell *)cell;
    
    EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:event];
//    NSString *imageName = event.imageID ?: @"EmptyPoster";
//    eventCell.thumbnailImageView.image = [UIImage imageNamed:imageName];
    eventCell.titleLabel.text = [event title];
    eventCell.detailLabel.text = [eventFormatter timeAndLocationString];
    eventCell.priceLabel.text = [eventFormatter priceString];
}

- (void)reloadPredicate
{
    NSArray *result = [self.eventStore eventsMatchingPredicate:[self eventsPredicate]];
    [self updateSectionsAndItemsWithResult:result];
    
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

- (void)updateSectionsAndItemsWithResult:(NSArray *)result
{
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSDictionary *items = [result classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:obj];
        NSString *sectionName = [eventFormatter dateSectionName];
        
        if ([sectionName isEqual:[sections lastObject]] == NO) {
            [sections addObject:sectionName];
        }
        
        return sectionName;
    }];
    
    self.sections = [sections copy];
    self.items = [items copy];
}

@end
 