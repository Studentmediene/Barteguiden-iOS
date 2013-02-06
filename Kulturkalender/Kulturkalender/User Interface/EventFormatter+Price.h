//
//  EventFormatter+Price.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"


@interface EventFormatter (Price)

+ (NSString *)stringForPrice:(NSDecimalNumber *)price;

- (NSString *)priceString;

@end
