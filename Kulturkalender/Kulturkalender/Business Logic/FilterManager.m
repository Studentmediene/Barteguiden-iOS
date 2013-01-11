//
//  FilterManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FilterManager.h"

NSString * const kCategoryFilterSelectionKey = @"CategoryFilterSelection";
NSString * const kAgeLimitMyAgeKey = @"AgeLimitMyAge";
NSString * const kAgeLimitSelectionKey = @"AgeLimitSelection";
NSString * const kPriceFilterSelectionKey = @"PriceFilterSelection";

@implementation FilterManager {
    NSUserDefaults *_userDefaults;
    NSMutableSet *_selectedCategories;
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
    }
    return self;
}

// TODO: Where to put this code?
//// Register defaults
//NSArray *allCategories = [ManagedEvent categoryIDs];
//NSDictionary *defaults = @{ kCategoryFilterSelectionKey : allCategories };
//[userDefaults registerDefaults:defaults];
//
//// Load selected categories
//NSArray *selectedCategories = [userDefaults objectForKey:kCategoryFilterSelectionKey];
//_selectedCategories = [NSMutableSet setWithArray:selectedCategories];


#pragma mark - Defaults


#pragma mark - Category filter

- (BOOL)isSelectedForCategoryID:(NSNumber *)categoryID
{
    BOOL isSelected = ([_selectedCategories containsObject:categoryID] == YES);
    return isSelected;
}

- (void)setSelected:(BOOL)selected forCategoryID:(NSNumber *)categoryID
{
    if (selected == YES) {
        [_selectedCategories addObject:categoryID];
    }
    else {
        [_selectedCategories removeObject:categoryID];
    }
}

- (void)toggleSelectedForCategoryID:(NSNumber *)categoryID
{
    BOOL isSelected = [self isSelectedForCategoryID:categoryID];
    [self setSelected:(isSelected == NO) forCategoryID:categoryID];
}


#pragma mark - Age limit filter

- (AgeLimitFilter)ageLimitFilter
{
    AgeLimitFilter ageLimitFilter = [_userDefaults integerForKey:kAgeLimitSelectionKey];
    return ageLimitFilter;
}

- (void)setAgeLimitFilter:(AgeLimitFilter)ageLimitFilter
{
    [_userDefaults setInteger:ageLimitFilter forKey:kAgeLimitSelectionKey];
}

- (NSNumber *)myAge
{
    NSNumber *myAge = [_userDefaults objectForKey:kAgeLimitMyAgeKey];
    return myAge;
}

- (void)setMyAge:(NSNumber *)myAge
{
    [_userDefaults setObject:myAge forKey:kAgeLimitMyAgeKey];
}


#pragma mark - Price filter

- (PriceFilter)priceFilter
{
    AgeLimitFilter priceFilter = [_userDefaults integerForKey:kPriceFilterSelectionKey];
    return priceFilter;
}

- (void)setPriceFilter:(PriceFilter)priceFilter
{
    [_userDefaults setInteger:priceFilter forKey:kPriceFilterSelectionKey];
}


#pragma mark - General methods

- (NSPredicate *)predicate
{
    // FIXME: Move method to MyPageViewController
    
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    // Category filter
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"categoryID IN %@", _selectedCategories];
    [predicates addObject:categoryPredicate];
    
    // Age filter
    if (self.ageLimitFilter == AgeLimitFilterShowAllowedForMyAge && [self.myAge unsignedIntegerValue] > 0) {
        NSPredicate *ageLimitFilter = [NSPredicate predicateWithFormat:@"ageLimit <= %@", self.myAge];
        [predicates addObject:ageLimitFilter];
    }
    
    // Price filter
    if (self.priceFilter == PriceFilterShowPaidEvents) {
        NSPredicate *priceFilter = [NSPredicate predicateWithFormat:@"price > 0"];
        [predicates addObject:priceFilter];
    }
    else if (self.priceFilter == PriceFilterShowFreeEvents) {
        NSPredicate *priceFilter = [NSPredicate predicateWithFormat:@"price == 0"];
        [predicates addObject:priceFilter];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    return predicate;
}

- (void)save
{
    NSArray *selectedCategories = [_selectedCategories allObjects];
    [_userDefaults setObject:selectedCategories forKey:kCategoryFilterSelectionKey];
    [_userDefaults synchronize];
}

@end
