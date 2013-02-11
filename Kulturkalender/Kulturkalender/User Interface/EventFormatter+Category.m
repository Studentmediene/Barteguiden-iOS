//
//  EventFormatter+Category.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Category.h"
#import "EventConstants.h"
#import "EventKit.h"


@implementation EventFormatter (Category)

- (NSString *)categoryString
{
    return [self categoryStringForCategory:[self.event category]];
}


#pragma mark - Private methods

- (NSString *)categoryStringForCategory:(EventCategory)category
{
    NSString *categoryKey = [self categoryKeyForCategory:category];
    NSString *categoryString = NSLocalizedStringFromTable(categoryKey, tbl, @"The category for an event");
    return categoryString;
}

- (NSString *)categoryKeyForCategory:(EventCategory)category
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
