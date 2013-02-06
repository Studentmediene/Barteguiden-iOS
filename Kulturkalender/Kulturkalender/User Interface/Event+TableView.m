//
//  Event+TableView.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+TableView.h"
#import "EventConstants.h"
#import "Event+Location.h"

@implementation Event (TableView)

- (NSString *)dateSectionName
{
    NSDateFormatter *dateFormatter = [[self class] dateSectionNameDateFormatter];
    
    // TODO: Fix
    // Get section name
//    BOOL startAtIsEarlierThanNow = [[self.startAt earlierDate:[NSDate date]] isEqualToDate:self.startAt];
//    NSDate *date = (startAtIsEarlierThanNow) ? self.startAt : [NSDate date];
    NSString *sectionName = [dateFormatter stringFromDate:self.startAt];
    return sectionName;
}

- (NSString *)timeAndLocationString
{
    NSDateFormatter *dateFormatter = [[self class] timeAndLocationStringDateFormatter];
    
    // TODO: Fix and remember localization
    NSString *format = NSLocalizedStringWithDefaultValue(@"TIME_AND_LOCATION_STRING_FORMAT", tbl, bundle, @"%1$@ at %2$@", @"Format for the time and location");
    NSString *timeAndLocation = [NSString stringWithFormat:format, [dateFormatter stringFromDate:self.startAt], self.placeName];
    
    return timeAndLocation;
}


#pragma mark - Private methods

+ (NSDateFormatter *)dateSectionNameDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    });
    
    return dateFormatter;
}

+ (NSDateFormatter *)timeAndLocationStringDateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    
    return dateFormatter;
}

@end

#pragma mark - Constants

NSString * const kEventSectionName = @"dateSectionName";