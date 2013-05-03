//
//  FilterManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "UserDefaultsFilterManager.h"


NSString * const kCategoryFilterSelectionKey = @"CategoryFilterSelection";
NSString * const kAgeLimitFilterMyAgeKey = @"AgeLimitFilterMyAge";
NSString * const kAgeLimitFilterSelectionKey = @"AgeLimitFilterSelection";
NSString * const kPriceFilterSelectionKey = @"PriceFilterSelection";


@interface UserDefaultsFilterManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) id<EventStore> eventStore;

@end


@implementation UserDefaultsFilterManager

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults eventStore:(id<EventStore>)eventStore
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
        _eventStore = eventStore;
    }
    return self;
}

- (void)save
{
    [self.userDefaults synchronize];
}


#pragma mark - Defaults

- (void)registerDefaultSelectedCategoryIDs:(CategoryFilter)categoryFilter
{
    [self.userDefaults registerDefaults:@{kCategoryFilterSelectionKey: @(categoryFilter)}];
}

- (void)registerDefaultAgeLimitFilter:(AgeLimitFilter)ageLimitFilter
{
    [self.userDefaults registerDefaults:@{kAgeLimitFilterSelectionKey: @(ageLimitFilter)}];
}

- (void)registerDefaultMyAge:(NSUInteger)myAge
{
    [self.userDefaults registerDefaults:@{kAgeLimitFilterMyAgeKey: @(myAge)}];
}

- (void)registerDefaultPriceFilter:(PriceFilter)priceFilter
{
    [self.userDefaults registerDefaults:@{kPriceFilterSelectionKey: @(priceFilter)}];
}


#pragma mark - Predicate

- (NSPredicate *)predicate
{
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    // Category filter
    NSPredicate *categoryPredicate = [self.eventStore predicateForEventsWithCategories:[self selectedCategories]];
    [predicates addObject:categoryPredicate];
    
    // Age filter
    if (self.ageLimitFilter == AgeLimitFilterShowAllowedForMyAge && self.myAge > 0) {
        NSPredicate *ageLimitFilter = [self.eventStore predicateForEventsAllowedForAge:self.myAge];
        [predicates addObject:ageLimitFilter];
    }
    
    // Price filter
    if (self.priceFilter == PriceFilterShowPaidEvents) {
        NSPredicate *priceFilter = [self.eventStore predicateForPaidEvents];
        [predicates addObject:priceFilter];
    }
    else if (self.priceFilter == PriceFilterShowFreeEvents) {
        NSPredicate *priceFilter = [self.eventStore predicateForFreeEvents];
        [predicates addObject:priceFilter];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    return predicate;
}


#pragma mark - Category filter

- (CategoryFilter)categoryFilter
{
    NSNumber *categoryFilter = [self.userDefaults objectForKey:kCategoryFilterSelectionKey];
    if (categoryFilter == nil) {
        return CategoryFilterShowAllEvents;
    }
    
    return [categoryFilter unsignedIntegerValue];
}

- (void)setCategoryFilter:(CategoryFilter)categoryFilter
{
    [self.userDefaults setObject:@(categoryFilter) forKey:kCategoryFilterSelectionKey];
}

- (BOOL)isSelectedForCategory:(EventCategory)category
{
    return (self.categoryFilter & (1 << category)) > 0;
}

- (void)setSelected:(BOOL)selected forCategory:(EventCategory)category
{
    if (selected == YES) {
        self.categoryFilter = self.categoryFilter | 1 << category;
    }
    else {
        self.categoryFilter = self.categoryFilter & ~(1 << category);
    }
}

- (void)toggleSelectedForCategory:(EventCategory)category
{
    BOOL isSelected = [self isSelectedForCategory:category];
    [self setSelected:(isSelected == NO) forCategory:category];
}


#pragma mark - Age limit filter

- (AgeLimitFilter)ageLimitFilter
{
    NSNumber *ageLimitFilter = [self.userDefaults objectForKey:kAgeLimitFilterSelectionKey];
    if (ageLimitFilter == nil) {
        return AgeLimitFilterShowAllEvents;
    }
    
    return [ageLimitFilter integerValue];
}

- (void)setAgeLimitFilter:(AgeLimitFilter)ageLimitFilter
{
    [self.userDefaults setObject:@(ageLimitFilter) forKey:kAgeLimitFilterSelectionKey];
}

- (NSUInteger)myAge
{
    NSNumber *myAge = [self.userDefaults objectForKey:kAgeLimitFilterMyAgeKey];
    return [myAge unsignedIntegerValue];
}

- (void)setMyAge:(NSUInteger)myAge
{
    [self.userDefaults setObject:@(myAge) forKey:kAgeLimitFilterMyAgeKey];
}


#pragma mark - Price filter

- (PriceFilter)priceFilter
{
    NSNumber *priceFilter = [self.userDefaults objectForKey:kPriceFilterSelectionKey];
    if (priceFilter == nil) {
        return PriceFilterShowAllEvents;
    }
    
    return [priceFilter integerValue];
}

- (void)setPriceFilter:(PriceFilter)priceFilter
{
    [self.userDefaults setObject:@(priceFilter) forKey:kPriceFilterSelectionKey];
}


#pragma mark - Private methods

- (NSArray *)selectedCategories
{
    NSMutableArray *selectedCategories = [NSMutableArray array];
    for (NSNumber *category in [self categories]) {
        if ([self isSelectedForCategory:[category unsignedIntegerValue]] == YES) {
            [selectedCategories addObject:category];
        }
    }
    
    return selectedCategories;
}

- (NSArray *)categories
{
    static NSArray *categories = nil;
    if (categories == nil) {
        categories = @[@(EventCategoryOther), @(EventCategoryConcerts), @(EventCategoryNightlife), @(EventCategoryTheatre), @(EventCategoryDance), @(EventCategoryArtExhibition), @(EventCategorySports), @(EventCategoryPresentations)];
    }
    
    return categories;
}

@end
