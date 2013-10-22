//
//  EventFormatter+TableView.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+TableView.h"
#import "EventKit.h"


@implementation EventFormatter (TableView)

- (NSString *)dateSectionName
{
    NSDateFormatter *dateFormatter = [self dateSectionNameDateFormatter];
    
    NSString *sectionName = [dateFormatter stringFromDate:[self.event startAt]];
    return [self capitalizeFirstLetter:sectionName];
}

- (NSString *)timeAndLocationString
{
    NSDateFormatter *dateFormatter = [self timeAndLocationStringDateFormatter];
    
    NSString *format = NSLocalizedStringFromTable(@"TIME_AND_LOCATION_STRING_FORMAT", @"Event", @"Format for the time and location");
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

- (NSString *)capitalizeFirstLetter:(NSString *)string
{
    NSString *firstCapChar = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    return cappedString;
}

@end