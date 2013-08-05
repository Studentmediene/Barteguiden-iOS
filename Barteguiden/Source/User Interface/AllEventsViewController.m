//
//  AllEventsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AllEventsViewController.h"
#import "EventKit.h"


#pragma mark - Constants

enum {
    kAllEventsSegmentedControllIndex = 0,
    kPaidEventsSegmentedControllIndex = 1,
    kFreeEventsSegmentedControllIndex = 2
};

@implementation AllEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AbstractEventsViewController

- (NSPredicate *)eventsPredicate
{
    NSPredicate *predicate = [super eventsPredicate];
    
    switch ([self.priceFilterSegmentedControl selectedSegmentIndex]) {
        case kPaidEventsSegmentedControllIndex: {
            NSPredicate *paidPredicate = [self.eventStore predicateForPaidEvents];
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, paidPredicate]];
            
            break;
        }
        case kFreeEventsSegmentedControllIndex: {
            NSPredicate *freePredicate = [self.eventStore predicateForFreeEvents];
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, freePredicate]];
            
            break;
        }
    }
    
    return predicate;
}


#pragma mark - IBAction

- (IBAction)changePriceFilter:(id)sender
{
    // TODO: Change back?
    [self.eventResultsController setPredicate:[self eventsPredicate] withAnimation:YES];
//    [self reloadPredicate];
    [self updatePlaceholderInSearchField];
}


#pragma mark - Private methods

- (void)updatePlaceholderInSearchField
{
    self.searchDisplayController.searchBar.placeholder = [self searchFieldPlaceholder];
}

- (NSString *)searchFieldPlaceholder
{
    // TODO: Fix localization
    switch ([self.priceFilterSegmentedControl selectedSegmentIndex]) {
        case kAllEventsSegmentedControllIndex:
        {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_ALL_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search All Events", @"Placeholder text in search field in all events tab");
        }
        case kPaidEventsSegmentedControllIndex:
        {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_PAID_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search Paid Events", @"Placeholder text in search field in all events tab");
        }
        case kFreeEventsSegmentedControllIndex:
        {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_FREE_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search Free Events", @"Placeholder text in search field in all events tab");
        }
    }
    
    return nil;
}

@end