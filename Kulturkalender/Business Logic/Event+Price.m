//
//  Event+Price.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Price.h"
#import "EventConstants.h"

const int kFreeEvent = 0;

@implementation Event (Price)

+ (NSString *)stringForPrice:(NSDecimalNumber *)price
{
    NSString *priceString = nil;
    
    if ([price isEqualToNumber:@(kFreeEvent)]) {
        priceString = NSLocalizedStringWithDefaultValue(@"PRICE_FREE_EVENT", tbl, bundle, @"Free", @"Free event");
    }
    else {
        // TODO: Replace with currency formatter? Maybe a bad idea because the price will always be in NOK
        NSString *format = NSLocalizedStringWithDefaultValue(@"PRICE_PAID_EVENT", tbl, bundle, @"%1$@kr", @"Format for paid event");
        priceString = [NSString stringWithFormat:format, price];
    }
    
    return priceString;
}

- (NSString *)priceString
{
    return [[self class] stringForPrice:self.price];
}

@end
