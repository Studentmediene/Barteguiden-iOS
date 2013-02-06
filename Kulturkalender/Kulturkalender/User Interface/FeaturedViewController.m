//
//  FeaturedEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FeaturedViewController.h"

@implementation FeaturedViewController

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
    
    NSPredicate *featuredPredicate = [self.eventStore predicateForFeaturedEvents];
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, featuredPredicate]];
    
    return predicate;
}

@end
