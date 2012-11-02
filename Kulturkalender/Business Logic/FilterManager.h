//
//  FilterManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PriceFilterShowAllEvents = 0,
    PriceFilterShowPaidEvents,
    PriceFilterShowFreeEvents
} PriceFilter;

@interface FilterManager : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefaults;

+ (id)sharedManager;

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults;

- (BOOL)isSelectedForCategoryID:(NSNumber *)categoryID;
- (void)setSelected:(BOOL)selected forCategoryID:(NSNumber *)categoryID;

// TOOD: Age limit

// TODO: Price
//- (PriceFilter)priceFilter;
//- (void)setPriceFilter:(PriceFilter)priceFilter;

- (NSPredicate *)predicate;
- (void)save;

@end
