//
//  FilterManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#ifndef Barteguiden_FilterManager_h
#define Barteguiden_FilterManager_h

#import "EventKit.h"


typedef NS_OPTIONS(NSUInteger, CategoryFilter) {
    CategoryFilterShowNoneEvents    = 0,
    CategoryFilterShowOther         = 1 << EventCategoryOther,
    CategoryFilterShowConcerts      = 1 << EventCategoryConcerts,
    CategoryFilterShowNightlife     = 1 << EventCategoryNightlife,
    CategoryFilterShowTheatre       = 1 << EventCategoryTheatre,
    CategoryFilterShowDance         = 1 << EventCategoryDance,
    CategoryFilterShowArtExhibition = 1 << EventCategoryArtExhibition,
    CategoryFilterShowSports        = 1 << EventCategorySports,
    CategoryFilterShowPresentations = 1 << EventCategoryPresentations,
    CategoryFilterShowAllEvents     = NSUIntegerMax
};

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

// Predicate
- (NSPredicate *)predicate;

// Category filter
@property (nonatomic) CategoryFilter categoryFilter;
- (BOOL)isSelectedForCategory:(EventCategory)category;
- (void)setSelected:(BOOL)selected forCategory:(EventCategory)category;
- (void)toggleSelectedForCategory:(EventCategory)category;

// Age limit filter
@property (nonatomic) AgeLimitFilter ageLimitFilter;
@property (nonatomic) NSUInteger myAge;

// Price filter
@property (nonatomic) PriceFilter priceFilter;

@end

#endif
