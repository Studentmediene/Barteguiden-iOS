//
//  EventFormatter+AgeLimit.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+AgeLimit.h"
#import "EventConstants.h"
#import "EventKit.h"


static int const kNoAgeLimit = 0;


@implementation EventFormatter (AgeLimit)


- (NSString *)ageLimitString
{
    return [self stringForAgeLimit:[self.event ageLimit]];
}


#pragma mark - Private methods

- (NSString *)stringForAgeLimit:(NSUInteger)ageLimit
{
    NSString *ageLimitString = nil;
    
    if (ageLimit == kNoAgeLimit) {
        ageLimitString = NSLocalizedStringFromTable(@"AGE_LIMIT_NO_AGE_LIMIT", tbl, @"No age limit");
    }
    else {
        NSString *format = NSLocalizedStringFromTable(@"AGE_LIMIT_ARBITRARY_AGE_LIMIT", tbl, @"Arbitrary age limit");
        ageLimitString = [NSString stringWithFormat:format, ageLimit];
    }
    
    return ageLimitString;
}

@end
