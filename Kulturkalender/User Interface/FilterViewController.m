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

@implementation FilterViewController {
    FilterManager *_filterManager;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _filterManager = [FilterManager sharedManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateViewInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"disappear");
    [self setMyAge];
}


#pragma mark - IBAction

- (IBAction)myAgeTextFieldDidEndEditing:(id)sender
{
    NSLog(@"End editing");
    [self setMyAge];
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
        BOOL isSelected = [_filterManager isSelectedForCategoryID:categoryID];
        
        cell.textLabel.text = [Event stringForCategoryID:categoryID];
        cell.accessoryType = (isSelected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
    
    // If the row is not selected, selected it, and vice verca
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case kCategorySectionIndex: {
            [self setCategoryFilterForCell:cell];
            break;
        }
        case kAgeLimitSectionIndex: {
            [self setAgeLimitFilterForCell:cell];
            break;
        }
        case kPriceSectionIndex: {
            [self setPriceFilterForCell:cell];
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}


#pragma mark - Category filter

- (void)updateCategoryFilterSelectedCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSNumber *categoryID = [[Event categoryIDs] objectAtIndex:indexPath.row];
    BOOL isSelected = [_filterManager isSelectedForCategoryID:categoryID];
    
    cell.accessoryType = (isSelected == YES) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setCategoryFilterForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSNumber *categoryID = [[Event categoryIDs] objectAtIndex:indexPath.row];
    [_filterManager toggleSelectedForCategoryID:categoryID];
    
    [self updateCategoryFilterSelectedCell];
}


#pragma mark - Age limit filter

- (void)updateAgeLimitFilterCells
{
    self.ageLimitAllEventsCell.accessoryType = (_filterManager.ageFilter == AgeLimitFilterShowAllEvents) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.ageLimitAllowedForMyAgeCell.accessoryType = (_filterManager.ageFilter == AgeLimitFilterShowAllowedForMyAge) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setAgeLimitFilterForCell:(UITableViewCell *)cell
{
    if (cell == self.ageLimitAllEventsCell) {
        _filterManager.ageFilter = AgeLimitFilterShowAllEvents;
    }
    else if (cell == self.ageLimitAllowedForMyAgeCell) {
        _filterManager.ageFilter = AgeLimitFilterShowAllowedForMyAge;
    }
    
    [self updateAgeLimitFilterCells];
}

- (void)updateMyAgeTextField
{
    if ([_filterManager.myAge unsignedIntegerValue] > 0) {
        self.myAgeTextField.text = [_filterManager.myAge stringValue];
    }
}

- (void)setMyAge
{
    NSNumber *myAge = [NSNumber numberWithUnsignedInteger:[self.myAgeTextField.text integerValue]];
    [_filterManager setMyAge:myAge];
}


#pragma mark - Price filter

- (void)updatePriceFilterCells
{
    self.priceFilterAllEventsCell.accessoryType = (_filterManager.priceFilter == PriceFilterShowAllEvents) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.priceFilterPaidEvents.accessoryType = (_filterManager.priceFilter == PriceFilterShowPaidEvents) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.priceFilterFreeEvents.accessoryType = (_filterManager.priceFilter == PriceFilterShowFreeEvents) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setPriceFilterForCell:(UITableViewCell *)cell
{
    if (cell == self.priceFilterAllEventsCell) {
        _filterManager.priceFilter = PriceFilterShowAllEvents;
    }
    else if (cell == self.priceFilterPaidEvents) {
        _filterManager.priceFilter = PriceFilterShowPaidEvents;
    }
    else if (cell == self.priceFilterFreeEvents) {
        _filterManager.priceFilter = PriceFilterShowFreeEvents;
    }
    
    [self updatePriceFilterCells];
}


#pragma mark - Private methods

- (void)hideKeyboard
{
    [self.tableView endEditing:YES];
}

- (void)updateViewInfo
{
    [self updateAgeLimitFilterCells];
    [self updateMyAgeTextField];
    [self updatePriceFilterCells];
}



@end
