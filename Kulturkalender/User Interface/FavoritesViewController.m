//
//  FavoritedEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController

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
    
    // Enable editing of favorites
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	// Do any additional setup after loading the view.
    NSLog(@"Favorites Tab");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - EventsViewController

- (NSPredicate *)predicate
{
    NSPredicate *favoritesPredicate = [NSPredicate predicateWithFormat:@"favorite == 1"];
    
    return favoritesPredicate;
}

- (NSString *)cacheName
{
    return @"FavoritesCache";
}

@end
