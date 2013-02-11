//
//  EventFormatter+TableView.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+TableView.h"
#import "EventConstants.h"
#import "EventKit.h"
#import "EventFormatter+Location.h"


@implementation EventFormatter (TableView)

- (NSString *)dateSectionName
{
    NSDateFormatter *dateFormatter = [self dateSectionNameDateFormatter];
    
    // TODO: Fix
    // Get section name
//    BOOL startAtIsEarlierThanNow = [[self.startAt earlierDate:[NSDate date]] isEqualToDate:self.startAt];
//    NSDate *date = (startAtIsEarlierThanNow) ? self.startAt : [NSDate date];
    NSString *sectionName = [dateFormatter stringFromDate:[self.event startAt]];
    return sectionName;
}

- (NSString *)timeAndLocationString
{
    NSDateFormatter *dateFormatter = [self timeAndLocationStringDateFormatter];
    
    // TODO: Fix and remember localization
    NSString *format = NSLocalizedStringFromTable(@"TIME_AND_LOCATION_STRING_FORMAT", tbl, @"Format for the time and location");
    NSString *timeAndLocation = [NSString stringWithFormat:format, [dateFormatter stringFromDate:[self.event startAt]], [self.event placeName]];
    
    return timeAndLocation;
}


#pragma mark - Private methods

- (NSDateFormatter *)dateSectionNameDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    }
    
    return dateFormatter;
}

- (NSDateFormatter *)timeAndLocationStringDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return dateFormatter;
}

@end