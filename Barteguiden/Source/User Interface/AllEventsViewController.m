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
    
    // WORKAROUND: Placeholder text and segmented control text is not retrieved from localization in iOS6
    // http://stackoverflow.com/questions/15075165/storyboard-base-localization-strings-file-does-not-localize-at-runtime
    [self updatePlaceholderInSearchField];
    
    NSString *allSegment = NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_SEGMENTED_CONTROL_TEXT_ALL_EVENTS", nil, [NSBundle mainBundle], @"All", @"Title of all events filter in all events tab");
    NSString *paidSegment = NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_SEGMENTED_CONTROL_TEXT_PAID_EVENTS", nil, [NSBundle mainBundle], @"Paid", @"Title of paid events filter in all events tab");
    NSString *freeSegment = NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_SEGMENTED_CONTROL_TEXT_FREE_EVENTS", nil, [NSBundle mainBundle], @"Free", @"Title of free events filter in all events tab");
    
    [self.priceFilterSegmentedControl setTitle:allSegment forSegmentAtIndex:kAllEventsSegmentedControllIndex];
    [self.priceFilterSegmentedControl setTitle:paidSegment forSegmentAtIndex:kPaidEventsSegmentedControllIndex];
    [self.priceFilterSegmentedControl setTitle:freeSegment forSegmentAtIndex:kFreeEventsSegmentedControllIndex];
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

- (NSString *)eventsCacheName
{
    switch ([self.priceFilterSegmentedControl selectedSegmentIndex]) {
        case kAllEventsSegmentedControllIndex: {
            return @"All";
        }
        case kPaidEventsSegmentedControllIndex: {
            return @"Paid";
        }
        case kFreeEventsSegmentedControllIndex: {
            return @"Free";
        }
    }
    
    return nil;
}


#pragma mark - IBAction

- (IBAction)changePriceFilter:(id)sender
{
    [self updatePlaceholderInSearchField];
    [self reloadData];
}


#pragma mark - Private methods

- (void)updatePlaceholderInSearchField
{
    self.searchDisplayController.searchBar.placeholder = [self searchFieldPlaceholder];
}

- (NSString *)searchFieldPlaceholder
{
    switch ([self.priceFilterSegmentedControl selectedSegmentIndex]) {
        case kAllEventsSegmentedControllIndex: {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_ALL_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search All Events", @"Placeholder text in search field in all events tab");
        }
        case kPaidEventsSegmentedControllIndex: {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_PAID_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search Paid Events", @"Placeholder text in search field in all events tab");
        }
        case kFreeEventsSegmentedControllIndex: {
            return NSLocalizedStringWithDefaultValue(@"ALL_EVENTS_FREE_EVENTS_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search Free Events", @"Placeholder text in search field in all events tab");
        }
    }
    
    return nil;
}

@end