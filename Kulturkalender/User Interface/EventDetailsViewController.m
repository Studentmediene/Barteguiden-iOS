//
//  EventDetailsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventManager.h"
#import "MapViewController.h"

@implementation EventDetailsViewController

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


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapSegue"])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.annotation = self.event.location;
    }
}


#pragma mark - IBAction

- (void)toggleFavorite:(id)sender
{
    BOOL isFavorite = ([self.event.favorite boolValue] == NO);
    
    self.event.favorite = @(isFavorite);
    
    self.favoriteButton.selected = isFavorite;
}

- (void)shareEvent:(id)sender
{
    NSArray *activityItems = @[ [UIImage imageNamed:@"EmptyPoster.png"], @"Test" ];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)toggleReminder:(id)sender
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
    
    self.favoriteButton.selected = [self.event.favorite boolValue];
}

@end
