//
//  Event+Price.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedEvent.h"

@interface ManagedEvent (Price)

+ (NSString *)stringForPrice:(NSDecimalNumber *)price;

- (NSString *)priceString;

@end
