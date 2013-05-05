//
//  EventFormatter+AgeLimit.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"


@interface EventFormatter (AgeLimit)

- (NSString *)ageLimitString;

+ (NSString *)stringForAgeLimit:(NSUInteger)ageLimit;

@end
