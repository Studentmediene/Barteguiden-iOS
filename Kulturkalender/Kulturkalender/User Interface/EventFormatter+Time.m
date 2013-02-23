//
//  EventFormatter+Time.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Time.h"
#import "EventConstants.h"
#import "EventKit.h"


@implementation EventFormatter (Time)

- (NSString *)timeString
{
    NSString *time = nil;
    
    if ([self.event endAt] == nil) {
        NSDateFormatter *dateFormatter = [self timeAndDateFormatter];
        
        NSString *format = @"Starts on %1$@";// TODO: Localize
        NSString *startAt = [dateFormatter stringFromDate:[self.event startAt]];
        time = [NSString stringWithFormat:format, startAt];
    }
    else {
        NSDateFormatter *startAtDateFormatter = [self timeAndDateFormatter];
        BOOL isSameDay = [self isSameDayWithDate1:[self.event startAt] date2:[self.event endAt]];
        NSDateFormatter *endAtDateFormatter = (isSameDay == YES) ? [self onlyTimeFormatter] : [self timeAndDateFormatter];
        
        NSString *format = @"From %1$@ to %2$@";// TODO: Localize
        NSString *startAt = [startAtDateFormatter stringFromDate:[self.event startAt]];
        NSString *endAt = [endAtDateFormatter stringFromDate:[self.event endAt]];
        time = [NSString stringWithFormat:format, startAt, endAt];
    }
    
//    if (self.) {
//
//    }
    
    // TODO: Fix and remember localization
    return time;
}


#pragma mark - Private methods

- (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date2];
    
    return ([comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year]);
}

- (NSDateFormatter *)timeAndDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = self.locale;
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return dateFormatter;
}

- (NSDateFormatter *)onlyTimeFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = self.locale;
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return dateFormatter;
}

@end