//
//  FilterManager.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 01.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FilterManager.h"
#import "EventManager.h"

NSString * const kSelectedCategories = @"selectedCategories";

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
        NSDictionary *defaults = @{ kSelectedCategories : allCategories };
        [userDefaults registerDefaults:defaults];
        
        // Load selected categories
        NSArray *selectedCategories = [userDefaults objectForKey:kSelectedCategories];
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


#pragma mark - Age limit filter

// TODO: Implement


#pragma mark - Price filter

// TODO: Implement


#pragma mark - General methods

- (NSPredicate *)predicate
{
    // TODO: Fix implementation
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"categoryID IN %@", _selectedCategories];
    return categoryPredicate;
}

- (void)save
{
    NSArray *selectedCategories = [_selectedCategories allObjects];
    [self.userDefaults setObject:selectedCategories forKey:kSelectedCategories];
    [self.userDefaults synchronize];
}

@end
