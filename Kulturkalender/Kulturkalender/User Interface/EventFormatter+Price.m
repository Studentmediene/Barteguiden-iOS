//
//  EventFormatter+Price.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter+Price.h"
#import "EventFormatterConstants.h"
#import "EventKit.h"


@implementation EventFormatter (Price)

- (NSString *)priceString
{
    return [[self class] stringForPrice:[self.event price]];
}

+ (NSString *)stringForPrice:(NSDecimalNumber *)price
{
    NSString *priceString = nil;
    
    if ([price isEqualToNumber:[NSDecimalNumber zero]]) {
        priceString = NSLocalizedStringFromTable(@"PRICE_FREE_EVENT", tbl, @"Free event");
    }
    else {
        // TODO: Replace with currency formatter?
        NSString *format = NSLocalizedStringFromTable(@"PRICE_PAID_EVENT", tbl, @"Format for paid event");
        priceString = [NSString stringWithFormat:format, price];
    }
    
    return priceString;
}

@end
