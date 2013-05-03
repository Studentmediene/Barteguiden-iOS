//
//  EventFormatter+Price.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"


@interface EventFormatter (Price)

- (NSString *)priceString;

+ (NSString *)stringForPrice:(NSDecimalNumber *)price;

@end
