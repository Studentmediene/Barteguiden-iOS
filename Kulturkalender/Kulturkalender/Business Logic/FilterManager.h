//
//  FilterManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AgeLimitFilterShowAllEvents = 0,
    AgeLimitFilterShowAllowedForMyAge
} AgeLimitFilter;

typedef enum {
    PriceFilterShowAllEvents = 0,
    PriceFilterShowPaidEvents,
    PriceFilterShowFreeEvents
} PriceFilter;

@protocol FilterManager <NSObject>

- (NSPredicate *)predicate;
- (void)save;

// Category filter
//- (NSArray *)selectedCategoryIDs;
- (BOOL)isSelectedForCategoryID:(NSNumber *)categoryID;
- (void)setSelected:(BOOL)selected forCategoryID:(NSNumber *)categoryID;
- (void)toggleSelectedForCategoryID:(NSNumber *)categoryID;

// Age limit filter
@property (nonatomic) AgeLimitFilter ageLimitFilter;
@property (nonatomic, strong) NSNumber *myAge;

// Price filter
@property (nonatomic) PriceFilter priceFilter;

@end


@interface FilterManager : NSObject <FilterManager>

@property (nonatomic, strong) NSUserDefaults *userDefaults;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

// Category filter
//- (void)registerDefaultSelectedCategoryIDs:(NSArray *)categoryIDs;

// Age limit filter
//- (void)registerDefaultAgeLimitFilter:(AgeLimitFilter)ageLimitFilter;

// Price filter
//- (void)registerDefaultPriceFilter:(PriceFilter)priceFilter;

@end
