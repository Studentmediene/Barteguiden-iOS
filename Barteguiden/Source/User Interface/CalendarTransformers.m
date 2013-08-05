//
//  CalendarTransformers.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "CalendarTransformers.h"
#import <NSValueTransformer+TransformerKit.h>
#import <EventKit/EventKit.h>
#import <TTTTimeIntervalFormatter.h>


NSString * const CalendarAlertDescriptionTransformerName = @"CalendarAlertDescriptionTransformerName";


@implementation CalendarTransformers

+ (void)load
{
    @autoreleasepool {
        [NSValueTransformer registerValueTransformerWithName:CalendarAlertDescriptionTransformerName transformedValueClass:[NSString class] returningTransformedValueWithBlock:^id(EKAlarm *alert) {
            if (alert == nil || [alert isEqual:[NSNull null]]) {
                return NSLocalizedStringWithDefaultValue(@"DEFAULT_CALENDAR_ALERT_NONE", nil, [NSBundle mainBundle], @"None", @"Name of item when no alert should be set (Displayed in default calendar alert)");
            }
            else {
                NSTimeInterval timeInterval = (alert.relativeOffset - 0.1); // WORKAROUND: -0.1 fixes rounding error in order to display correct value
                return [[self timeIntervalFormatter] stringForTimeInterval:timeInterval];
            }
        }];
    }
}

+ (TTTTimeIntervalFormatter *)timeIntervalFormatter
{
    static TTTTimeIntervalFormatter *timeIntervalFormatter = nil;
    if (timeIntervalFormatter == nil) {
        timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        timeIntervalFormatter.locale = [NSLocale currentLocale];
        timeIntervalFormatter.usesIdiomaticDeicticExpressions = NO;
        timeIntervalFormatter.presentDeicticExpression = NSLocalizedStringWithDefaultValue(@"DEFAULT_CALENDAR_ALERT_AT_TIME_OF_EVENT", nil, [NSBundle mainBundle], @"At time of event", @"Name of item where an alert should be set to the time of event (Displayed in default calendar alert)");
        timeIntervalFormatter.pastDeicticExpression = NSLocalizedStringWithDefaultValue(@"DEFAULT_CALENDAR_ALERT_TIME_INTERVAL_APPENDED_TEXT", nil, [NSBundle mainBundle], @"before", @"Text appended after a time interval, e.g. 5 minutes before (Displayed in default calendar alert)");
    }
    
    return timeIntervalFormatter;
}

@end
