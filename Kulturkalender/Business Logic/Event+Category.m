//
//  Event+Category.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Category.h"
#import "EventLocalization.h"

@implementation Event (Category)

+ (NSArray *)categoryIDs
{
    static NSArray *categoryIDs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categoryIDs = @[ @0, @1, @2, @3, @4, @5, @6 ];
    });
    
    return categoryIDs;
}

+ (NSString *)stringForCategoryID:(NSNumber *)categoryID
{
    NSString *categoryKey = [self categoryKeys][categoryID];
    NSString *categoryString = NSLocalizedStringWithDefaultValue(categoryKey, tbl, bundle, @"Unknown", @"The category for an event");
    
    return categoryString;
}

- (NSString *)categoryString
{
    return [[self class] stringForCategoryID:self.categoryID];
}


#pragma mark - Private methods

+ (NSDictionary *)categoryKeys
{
    static NSDictionary *categories = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categories = @{
        @0 : @"CATEGORY_CONCERTS",
        @1 : @"CATEGORY_NIGHTLIFE",
        @2 : @"CATEGORY_THEATRE",
        @3 : @"CATEGORY_DANCE",
        @4 : @"CATEGORY_ART_EXHIBITION",
        @5 : @"CATEGORY_SPORTS",
        @6 : @"CATEGORY_PRESENTATIONS"
        };
    });
    
    return categories;
}

@end
