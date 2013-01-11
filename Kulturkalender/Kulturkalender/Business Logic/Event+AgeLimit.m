//
//  Event+AgeLimit.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+AgeLimit.h"
#import "EventConstants.h"

enum {
    kNoAgeLimit = 0
};

@implementation Event (AgeLimit)

+ (NSString *)stringForAgeLimit:(NSNumber *)ageLimit
{
    NSString *ageLimitString = nil;
    
    if ([ageLimit isEqualToNumber:@(kNoAgeLimit)]) {
        ageLimitString = NSLocalizedStringWithDefaultValue(@"AGE_LIMIT_NO_AGE_LIMIT", tbl, bundle, @"No age Limit", @"No age limit for an event");
    }
    else {
        NSString *format = NSLocalizedStringWithDefaultValue(@"AGE_LIMIT_ARBITRARY_AGE_LIMIT", tbl, bundle, @"%$1u and Above", @"Format for a specific age limit for an event");
        ageLimitString = [NSString stringWithFormat:format, ageLimit];
    }
    
    return ageLimitString;
}

- (NSString *)ageLimitString
{
    return [[self class] stringForAgeLimit:self.ageLimit];
}

@end
