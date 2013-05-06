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
                return NSLocalizedString(@"None", nil);
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
        timeIntervalFormatter.presentDeicticExpression = NSLocalizedString(@"At time of event", nil);
        timeIntervalFormatter.pastDeicticExpression = NSLocalizedString(@"before", nil);
    }
    
    return timeIntervalFormatter;
}

@end
