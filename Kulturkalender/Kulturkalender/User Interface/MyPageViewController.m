//
//  MyPageViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MyPageViewController.h"
#import "FilterManager.h"

@implementation MyPageViewController

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
    
    NSPredicate *filterPredicate = [self.filterManager predicate];
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, filterPredicate]];
    
    return predicate;
}


#pragma mark - Unwind segues

- (IBAction)close:(UIStoryboardSegue *)segue
{
    NSLog(@"Closing filter");
    
    [self reloadPredicate];
}

@end
