//
//  EventFormatter+Price.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter+Price.h"
#import "EventKit.h"


@implementation EventFormatter (Price)

- (NSString *)priceString
{
    return [[self class] stringForPrice:[self.event price]];
}

+ (NSString *)stringForPrice:(NSDecimalNumber *)price
{
    return [[self currencyFormatter] stringFromNumber:price];
}


#pragma mark - Private methods

+ (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *currencyFormatter;
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.positiveSuffix = @",-";
        currencyFormatter.groupingSeparator = @" ";
        currencyFormatter.groupingSize = 3;
        currencyFormatter.usesGroupingSeparator = YES;
    }
    
    return currencyFormatter;
}

@end
