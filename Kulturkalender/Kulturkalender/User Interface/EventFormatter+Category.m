//
//  EventFormatter+Category.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Category.h"
#import "EventConstants.h"


@implementation EventFormatter (Category)

- (NSString *)categoryString
{
    return [[self class] categoryStringForCategory:[self.event category]];
}

+ (NSString *)categoryStringForCategory:(EventCategory)category
{
    NSString *categoryKey = [[self class] categoryKeyForCategory:category];
    NSString *categoryString = NSLocalizedStringFromTable(categoryKey, tbl, @"The category for an event");
    return categoryString;
}


#pragma mark - Private methods

+ (NSString *)categoryKeyForCategory:(EventCategory)category
{
    switch (category) {
        case EventCategoryConcerts:
            return @"CATEGORY_CONCERTS";
        case EventCategoryNightlife:
            return @"CATEGORY_NIGHTLIFE";
        case EventCategoryTheatre:
            return @"CATEGORY_THEATRE";
        case EventCategoryDance:
            return @"CATEGORY_DANCE";
        case EventCategoryArtExhibition:
            return @"CATEGORY_ART_EXHIBITION";
        case EventCategorySports:
            return @"CATEGORY_SPORTS";
        case EventCategoryPresentations:
            return @"CATEGORY_PRESENTATIONS";
        default:
            return @"CATEGORY_UNKNOWN";
    }
}

@end
