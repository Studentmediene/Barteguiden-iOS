//
//  EventDetailsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventManager.h"

@implementation EventDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViewInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - IBAction

- (void)addToFavorite:(id)sender
{
    UIButton *button = sender;
    button.selected = !(button.selected);
}

- (void)share:(id)sender
{
    NSLog(@"Share");
}

- (void)addToCalendar:(id)sender
{
    NSLog(@"Add to Calendar");
}


#pragma mark - Private methods

- (void)updateViewInfo
{
    self.titleLabel.text = self.event.title;
    self.timeLabel.text = self.event.timeString;
    self.categoryLabel.text = self.event.categoryString;
    self.priceLabel.text = self.event.priceString;
    self.ageLimitLabel.text = self.event.ageLimitString;
    self.descriptionLabel.text = self.event.currentLocalizedDescription;
    
    self.featuredLabel.text = self.event.currentLocalizedFeatured;
    
    self.placeNameLabel.text = self.event.location.placeName;
    self.addressLabel.text = self.event.location.address;
}

@end
