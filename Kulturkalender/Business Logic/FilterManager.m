//
//  FilterManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FilterManager.h"
#import "EventManager.h" // TODO: Remove dependency on EventManager? Hard to test at the moment

NSString * const kCategoryFilterSelection = @"CategoryFilterSelection";
NSString * const kAgeLimitMyAge = @"AgeLimitMyAge";
NSString * const kAgeLimitSelection = @"AgeLimitSelection";
NSString * const kPriceFilterSelection = @"PriceFilterSelection";

@implementation FilterManager {
    NSMutableSet *_selectedCategories;
}

static FilterManager *_sharedManager;

+ (id)sharedManager
{
    return _sharedManager;
}

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
        _sharedManager = self;
        
        // Register defaults
        NSArray *allCategories = [Event categoryIDs];
        NSDictionary *defaults = @{ kCategoryFilterSelection : allCategories };
        [userDefaults registerDefaults:defaults];
        
        // Load selected categories
        NSArray *selectedCategories = [userDefaults objectForKey:kCategoryFilterSelection];
        _selectedCategories = [NSMutableSet setWithArray:selectedCategories];
    }
    return self;
}


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

- (AgeLimitFilter)ageFilter
{
    AgeLimitFilter ageFilter = [self.userDefaults integerForKey:kAgeLimitSelection];
    return ageFilter;
}

- (void)setAgeFilter:(AgeLimitFilter)ageFilter
{
    [self.userDefaults setInteger:ageFilter forKey:kAgeLimitSelection];
}

- (NSNumber *)myAge
{
    NSNumber *myAge = [self.userDefaults objectForKey:kAgeLimitMyAge];
    return myAge;
}

- (void)setMyAge:(NSNumber *)myAge
{
    [self.userDefaults setObject:myAge forKey:kAgeLimitMyAge];
}


#pragma mark - Price filter

- (PriceFilter)priceFilter
{
    AgeLimitFilter priceFilter = [self.userDefaults integerForKey:kPriceFilterSelection];
    return priceFilter;
}

- (void)setPriceFilter:(PriceFilter)priceFilter
{
    [self.userDefaults setInteger:priceFilter forKey:kPriceFilterSelection];
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
    if (self.ageFilter == AgeLimitFilterShowAllowedForMyAge && [self.myAge unsignedIntegerValue] > 0) {
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
    [self.userDefaults setObject:selectedCategories forKey:kCategoryFilterSelection];
    [self.userDefaults synchronize];
}

@end
