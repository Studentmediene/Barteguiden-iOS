//
//  EventFormatter+AgeLimit.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+AgeLimit.h"
#import "EventKit.h"


static int const kNoAgeLimit = 0;


@implementation EventFormatter (AgeLimit)


- (NSString *)ageLimitString
{
    return [[self class] stringForAgeLimit:[self.event ageLimit]];
}

+ (NSString *)stringForAgeLimit:(NSUInteger)ageLimit
{
    NSString *ageLimitString = nil;
    
    if (ageLimit == kNoAgeLimit) {
        ageLimitString = NSLocalizedStringFromTable(@"AGE_LIMIT_NO_AGE_LIMIT", @"Event", @"No age limit");
    }
    else {
        NSString *format = NSLocalizedStringFromTable(@"AGE_LIMIT_ARBITRARY_AGE_LIMIT", @"Event", @"Arbitrary age limit");
        ageLimitString = [NSString stringWithFormat:format, ageLimit];
    }
    
    return ageLimitString;
}

@end
