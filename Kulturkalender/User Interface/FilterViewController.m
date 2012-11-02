//
//  FilterViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 31.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FilterViewController.h"
#import "EventManager.h"
#import "FilterManager.h"

enum {
    kCategorySectionIndex = 0,
    kAgeLimitSectionIndex = 1,
    kMyAgeSectionIndex = 2,
    kPriceSectionIndex = 3
};

@implementation FilterViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kCategorySectionIndex) {
        return [[Event categoryIDs] count];
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == kCategorySectionIndex) {
        static NSString *cellIdentifier = @"CategoryCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSNumber *categoryID = [[Event categoryIDs] objectAtIndex:indexPath.row];
        BOOL isSelected = [[FilterManager sharedManager] isSelectedForCategoryID:categoryID];
        
        cell.textLabel.text = [Event stringForCategoryID:categoryID];
        cell.accessoryType = (isSelected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kCategorySectionIndex: {
            NSNumber *categoryID = [[Event categoryIDs] objectAtIndex:indexPath.row];
            BOOL isSelected = [[FilterManager sharedManager] isSelectedForCategoryID:categoryID];
            
            // If the row is not selected, selected it, and vice verca
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = (isSelected == NO) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            
            // Update the selected categories
            [[FilterManager sharedManager] setSelected:(isSelected == NO) forCategoryID:categoryID];
        
            break;
        }
        case kAgeLimitSectionIndex: {
            
            break;
        }
        case kPriceSectionIndex: {
            
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

@end
