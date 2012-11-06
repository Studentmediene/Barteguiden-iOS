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
    
    // Hide search bar as default
    self.tableView.contentOffset = CGPointMake(0.0, self.tableView.tableHeaderView.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AbstractEventsViewController

- (NSPredicate *)predicate
{
    NSPredicate *predicate = [super predicate];
    
    NSPredicate *featuredPredicate = [NSPredicate predicateWithFormat:@"featured == 1"];
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ predicate, featuredPredicate ]];
    
    return predicate;
}

- (NSString *)cacheName
{
    return @"FeaturedCache";
}

@end
