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


static int kNoneAlertRow = 0;


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
    EKAlarm *alert = [self alertForIndexPath:indexPath];
    
    cell.textLabel.text = [[self class] alertDescriptionForAlert:alert];
    cell.accessoryType = ([self isAlertSelected:alert]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (EKAlarm *)alertForIndexPath:(NSIndexPath *)indexPath
{
    id alert = [[self alerts] objectAtIndex:indexPath.row];
    if (alert == [NSNull null]) {
        return nil;
    }
    
    return alert;
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

+ (NSString *)alertDescriptionForAlert:(EKAlarm *)alert
{
    if (alert == nil) {
        return [[self alertDescriptions] objectForKey:[NSNull null]];
    }
    
    return [[self alertDescriptions] objectForKey:@(alert.relativeOffset)];
}

+ (NSDictionary *)alertDescriptions
{
    static NSDictionary *alertDescriptions = nil;
    if (alertDescriptions == nil) {
        NSInteger min = 60;
        NSInteger hour = 60 * min;
        NSInteger day = 24 * hour;
        
        alertDescriptions = @{
            [NSNull null]: NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_NONE", nil, [NSBundle mainBundle], @"None", @"None-alert in alert chooser"),
            @0: NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_AT_TIME_OF_EVENT", nil, [NSBundle mainBundle], @"At time of event", @"At time of event-alert in alert chooser"),
            @(-5*min): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_5_MINUTES_BEFORE", nil, [NSBundle mainBundle], @"5 minutes before", @"5 minutes before-alert in alert chooser"),
            @(-15*min): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_15_MINUTES_BEFORE", nil, [NSBundle mainBundle], @"15 minutes before", @"15 minutes before-alert in alert chooser"),
            @(-30*min): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_30_MINUTES_BEFORE", nil, [NSBundle mainBundle], @"30 minutes before", @"30 minutes before-alert in alert chooser"),
            @(-1*hour): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_1_HOUR_BEFORE", nil, [NSBundle mainBundle], @"1 hour before", @"1 hour before-alert in alert chooser"),
            @(-2*hour): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_2_HOURS_BEFORE", nil, [NSBundle mainBundle], @"2 hours before", @"2 hours before-alert in alert chooser"),
            @(-1*day): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_1_DAY_BEFORE", nil, [NSBundle mainBundle], @"1 day before", @"1 day before-alert in alert chooser"),
            @(-2*day): NSLocalizedStringWithDefaultValue(@"ALERT_CHOOSER_ALERT_2_DAYS_BEFORE", nil, [NSBundle mainBundle], @"2 days before", @"2 days before-alert in alert chooser")
        };
    }
    
    return alertDescriptions;
}

- (BOOL)isAlertSelected:(EKAlarm *)alert
{
    BOOL isNoneSelected = (alert == nil && self.selectedAlert == nil);
    BOOL isOtherSelected = (alert != nil && self.selectedAlert != nil && alert.relativeOffset == self.selectedAlert.relativeOffset);
    return (isNoneSelected || isOtherSelected);
}

- (NSIndexPath *)removeCheckmarkFromPreviousCell
{
    __block NSUInteger previousRow = kNoneAlertRow; // Deselect 'None'-alert as default
    [[self alerts] enumerateObjectsUsingBlock:^(EKAlarm *alert, NSUInteger index, BOOL *stop) {
        if ([alert isEqual:[NSNull null]]) {
            alert = nil;
        }
        
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
