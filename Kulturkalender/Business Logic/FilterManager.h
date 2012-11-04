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

@interface FilterManager : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefaults;

+ (id)sharedManager;

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults;

- (NSPredicate *)predicate;
- (void)save;

// Category filter
- (BOOL)isSelectedForCategoryID:(NSNumber *)categoryID;
- (void)setSelected:(BOOL)selected forCategoryID:(NSNumber *)categoryID;
- (void)toggleSelectedForCategoryID:(NSNumber *)categoryID;

// Age limit filter
@property (nonatomic) AgeLimitFilter ageFilter;
@property (nonatomic, strong) NSNumber *myAge;

// Price filter
@property (nonatomic) PriceFilter priceFilter;

@end
