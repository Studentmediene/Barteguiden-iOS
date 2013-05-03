//
//  MyPageViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MyPageViewController.h"
#import "EventKit.h"
#import "UserDefaultsFilterManager.h"
#import "FilterViewController.h"


static NSString * kFilterSegue = @"FilterSegue";


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


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kFilterSegue]) {
        UINavigationController *navigationController = [segue destinationViewController];
        FilterViewController *filterViewController = (FilterViewController *)[navigationController topViewController];
        filterViewController.filterManager = self.filterManager;
    }
}

- (IBAction)close:(UIStoryboardSegue *)segue
{
    NSLog(@"Closing filter");
    
    [self reloadPredicate];
}

@end
