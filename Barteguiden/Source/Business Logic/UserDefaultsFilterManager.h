//
//  UserDefaultsFilterManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterManager.h"


@interface UserDefaultsFilterManager : NSObject <FilterManager>

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults eventStore:(id<EventStore>)eventStore;

- (void)save;

// Defaults
- (void)registerDefaultSelectedCategoryIDs:(CategoryFilter)categoryFilter;
- (void)registerDefaultAgeLimitFilter:(AgeLimitFilter)ageLimitFilter;
- (void)registerDefaultMyAge:(NSUInteger)myAge;
- (void)registerDefaultPriceFilter:(PriceFilter)priceFilter;

@end
