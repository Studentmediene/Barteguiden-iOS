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
    NSDateFormatter *dateFormatter = [self timeAndDateFormatter];
    
    NSString *format = @"Starts on %1$@";// TODO: Localize
    NSString *startAt = [dateFormatter stringFromDate:[self.event startAt]];
    NSString *time = [NSString stringWithFormat:format, startAt];
    
    return time;
}


#pragma mark - Private methods

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

@end
