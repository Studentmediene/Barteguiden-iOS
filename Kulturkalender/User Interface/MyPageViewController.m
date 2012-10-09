//
//  MyPageViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MyPageViewController.h"

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    // TODO: Implement
    return nil;
}

- (NSString *)cacheName
{
    return @"MyPageCache";
}


#pragma mark - Unwind segues

- (IBAction)close:(UIStoryboardSegue *)segue
{
    NSLog(@"Closing filter");
    
    [self reloadPredicate];
}

@end
