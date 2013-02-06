//
//  EventFormatter+AgeLimit.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+AgeLimit.h"
#import "EventFormatterConstants.h"
#import "EventKit.h"


static int const kNoAgeLimit = 0;


@implementation EventFormatter (AgeLimit)


- (NSString *)ageLimitString
{
    return [[self class] stringForAgeLimit:[self.event ageLimit]];
}

+ (NSString *)stringForAgeLimit:(NSNumber *)ageLimit
{
    // TODO: Fix implementation
    return [ageLimit stringValue];
//    NSString *priceString = nil;
//    
//    if ([price isEqualToNumber:[NSDecimalNumber zero]]) {
//        priceString = NSLocalizedStringFromTable(@"PRICE_FREE_EVENT", tbl, @"Free event");
//    }
//    else {
//        // TODO: Replace with currency formatter?
//        NSString *format = NSLocalizedStringFromTable(@"PRICE_PAID_EVENT", tbl, @"Format for paid event");
//        priceString = [NSString stringWithFormat:format, price];
//    }
//    
//    return priceString;
}

@end
