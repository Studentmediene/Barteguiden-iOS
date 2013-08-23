//
//  FeaturedEventsViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FeaturedViewController.h"
#import "EventKit.h"


@implementation FeaturedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // WORKAROUND: Placeholder text and segmented control text is not retrieved from localization in iOS6
    // http://stackoverflow.com/questions/15075165/storyboard-base-localization-strings-file-does-not-localize-at-runtime
    self.searchDisplayController.searchBar.placeholder = NSLocalizedStringWithDefaultValue(@"FEATURED_SEARCH_FIELD_PLACEHOLDER", nil, [NSBundle mainBundle], @"Search Featured", @"Placeholder text in search field in featured tab");
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
    
    NSPredicate *featuredPredicate = [self.eventStore predicateForFeaturedEvents];
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, featuredPredicate]];
    
    return predicate;
}

- (NSString *)eventsCacheName
{
    return @"Featured";
}

@end
