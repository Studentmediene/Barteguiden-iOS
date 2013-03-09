//
//  EventFormatter+Price.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter+Price.h"
#import "EventConstants.h"
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
        priceString = [[self currencyFormatter] stringFromNumber:price];
    }
    
    return priceString;
}


#pragma mark - Private methods

+ (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *currencyFormatter;
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.positiveSuffix = @"kr";
        currencyFormatter.groupingSeparator = @" ";
        currencyFormatter.groupingSize = 3;
        currencyFormatter.usesGroupingSeparator = YES;
    }
    
    return currencyFormatter;
}

@end
