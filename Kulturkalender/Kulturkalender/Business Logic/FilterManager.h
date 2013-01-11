//
//  FilterManager.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AgeLimitFilter) {
    AgeLimitFilterShowAllEvents = 0,
    AgeLimitFilterShowAllowedForMyAge
};

typedef NS_ENUM(NSInteger, PriceFilter) {
    PriceFilterShowAllEvents = 0,
    PriceFilterShowPaidEvents,
    PriceFilterShowFreeEvents
};

@protocol FilterManager <NSObject>

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

- (NSPredicate *)predicate;
- (void)save;

@end


@interface FilterManager : NSObject <FilterManager>

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

// Defaults
//- (void)registerDefaultSelectedCategoryIDs:(NSArray *)categoryIDs;
//- (void)registerDefaultAgeLimitFilter:(AgeLimitFilter)ageLimitFilter;
//- (void)registerDefaultPriceFilter:(PriceFilter)priceFilter;

@end
