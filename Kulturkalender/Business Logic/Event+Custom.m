//
//  Event+Custom.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Custom.h"
#import "Location.h"

@implementation Event (Custom)

- (NSString *)dateSectionName
{
    // Set date formatter
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    });
    
    // Get section name
    BOOL startAtIsEarlierThanNow = [[self.startAt earlierDate:[NSDate date]] isEqualToDate:self.startAt];
    NSDate *date = (startAtIsEarlierThanNow) ? self.startAt : [NSDate date];
    NSString *sectionName = [dateFormatter stringFromDate:date];
    return sectionName;
}

- (NSString *)timeAndLocationString
{
    // TODO: Fix and remember localization
    
    // Set date formatter
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    
    NSString *timeAndLocation = [NSString stringWithFormat:@"%@ at %@", [dateFormatter stringFromDate:self.startAt], self.location.placeName];
    
    return timeAndLocation;
}

@end

#pragma mark - Constants

NSString * const kEventSectionName = @"dateSectionName";