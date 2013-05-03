//
//  EventFormatter.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"
#import "EventKit.h"


@implementation EventFormatter

- (instancetype)initWithEvent:(id<Event>)event
{
    self = [super init];
    if (self) {
        _event = event;
        _locale = [NSLocale currentLocale];
    }
    return self;
}


@end
