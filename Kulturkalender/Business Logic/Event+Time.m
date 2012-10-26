//
//  Event+Time.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Time.h"

@implementation Event (Time)

- (NSString *)timeString
{
    // TODO: Fix and remember localization
    return [self.startAt description];
}

@end
