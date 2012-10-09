//
//  Event+Custom.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Custom.h"

@implementation Event (Custom)

- (NSString *)sectionName
{
    static NSDateFormatter *dateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    });
    
    return [dateFormatter stringFromDate:self.timeStartAt];
}

@end
