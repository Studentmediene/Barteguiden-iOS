//
//  SettingsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

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
	// Do any additional setup after loading the view.
    NSLog(@"Settings Tab");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - EventsViewController

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    
    // Add sort descriptor
    //    NSSortDescriptor *acceptedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"requestAccepted" ascending:YES];
    //    NSSortDescriptor *createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    //    NSArray *sortDescriptors = @[ createdAtSortDescriptor ];
    NSArray *sortDescriptors = @[];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}

- (NSString *)cacheName
{
    return @"Settings";
}

@end
