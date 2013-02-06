//
//  EventFormatter+Category.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Category.h"
#import "EventFormatterConstants.h"
#import "EventKit.h"


@implementation EventFormatter (Category)

- (NSString *)categoryString
{
    // TODO: Fix implementation
    return [NSString stringWithFormat:@"CATEGORY:%d", [self.event category]];
}

//+ (NSArray *)categoryIDs
//{
//    static NSArray *categoryIDs = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        categoryIDs = @[ @"CATEGORY_CONCERTS",
//                         @"CATEGORY_NIGHTLIFE",
//                         @"CATEGORY_THEATRE",
//                         @"CATEGORY_DANCE",
//                         @"CATEGORY_ART_EXHIBITION",
//                         @"CATEGORY_SPORTS",
//                         @"CATEGORY_PRESENTATIONS"
//                         ];
//    });
//    
//    return categoryIDs;
//}
//
//+ (NSString *)stringForCategoryID:(NSString *)categoryID
//{
//    NSString *categoryString = NSLocalizedStringFromTable(categoryID, tbl, @"The category for an event");
//    
//    return categoryString;
//}
//
//- (NSString *)categoryString
//{
//    return [[self class] stringForCategoryID:[self.event categoryID]];
//}


//#pragma mark - Private methods
//
//+ (NSDictionary *)categoryKeys
//{
//    static NSDictionary *categories = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        categories = @{
//        @0 : @"CATEGORY_CONCERTS",
//        @1 : @"CATEGORY_NIGHTLIFE",
//        @2 : @"CATEGORY_THEATRE",
//        @3 : @"CATEGORY_DANCE",
//        @4 : @"CATEGORY_ART_EXHIBITION",
//        @5 : @"CATEGORY_SPORTS",
//        @6 : @"CATEGORY_PRESENTATIONS"
//        };
//    });
//    
//    return categories;
//}

@end
