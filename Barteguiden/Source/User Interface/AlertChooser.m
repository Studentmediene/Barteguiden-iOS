//
//  DefaultAlertViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 05.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "AlertChooser.h"
#import "AlertChooserDelegate.h"
#import <EventKit/EventKit.h>
#import "CalendarTransformers.h"


static NSUInteger const kNoneAlertRow = 0;


@implementation AlertChooser

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Alert";
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


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self alerts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AlertCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *previousIndexPath = [self removeCheckmarkFromPreviousCell];
    [self addCheckmarkToNewCellAtIndexPath:indexPath];
    
    if ([previousIndexPath isEqual:indexPath] == NO) {
        [self.delegate alertChooserSelectionDidChange:self];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Private methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    EKAlarm *alert = [[self alerts] objectAtIndex:indexPath.row];
    
    NSValueTransformer *alertDescription = [NSValueTransformer valueTransformerForName:CalendarAlertDescriptionTransformerName];
    cell.textLabel.text = [alertDescription transformedValue:alert];
    cell.accessoryType = ([self isAlertSelected:alert]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (NSArray *)alerts
{
    static NSArray *alerts = nil;
    if (alerts == nil) {
        NSInteger min = 60;
        NSInteger hour = 60 * min;
        NSInteger day = 24 * hour;
        NSArray *timeIntervals = @[@0, @(-5*min), @(-15*min), @(-30*min), @(-1*hour), @(-2*hour), @(-1*day), @(-2*day)];
        
        NSMutableArray *mutableAlerts = [NSMutableArray arrayWithObject:[NSNull null]];
        for (NSNumber *timeInterval in timeIntervals) {
            [mutableAlerts addObject:[EKAlarm alarmWithRelativeOffset:[timeInterval doubleValue]]];
        }
        
        alerts = [mutableAlerts copy];
    }
    
    return alerts;
}

- (BOOL)isAlertSelected:(EKAlarm *)alert
{
    BOOL isNoneSelected = ([alert isEqual:[NSNull null]] == YES && self.selectedAlert == nil);
    BOOL isOtherSelected = ([alert isEqual:[NSNull null]] == NO && self.selectedAlert != nil && alert.relativeOffset == self.selectedAlert.relativeOffset);
    return (isNoneSelected || isOtherSelected);
}

- (NSIndexPath *)removeCheckmarkFromPreviousCell
{
    __block NSUInteger previousRow = kNoneAlertRow; // Deselect 'None'-alert as default
    [[self alerts] enumerateObjectsUsingBlock:^(EKAlarm *alert, NSUInteger index, BOOL *stop) {
        if ([self isAlertSelected:alert]) {
            previousRow = index;
            *stop = YES;
        }
    }];
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:previousRow inSection:0];
    UITableViewCell *previousCell = [self.tableView cellForRowAtIndexPath:previousIndexPath];
    previousCell.accessoryType = UITableViewCellAccessoryNone;
    
    return previousIndexPath;
}

- (void)addCheckmarkToNewCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    id newValue = [[self alerts] objectAtIndex:indexPath.row];
    newValue = (newValue != [NSNull null]) ? newValue : nil;
    self.selectedAlert = newValue;
}

@end
