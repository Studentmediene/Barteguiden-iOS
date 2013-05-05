//
//  EventFormatter+Category.m
//  Barteguiden
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

- (UIImage *)categoryImage
{
    return [[self class] categoryImageForCategory:[self.event category]];
}

+ (UIImage *)categoryImageForCategory:(EventCategory)category
{
    NSString *categoryImageName = [[self class] categoryImageNameForCategory:category];
    UIImage *categoryImage = [UIImage imageNamed:categoryImageName];
    return categoryImage;
}

- (UIImage *)categoryBigImage
{
    return [[self class] categoryBigImageForCategory:[self.event category]];
}

+ (UIImage *)categoryBigImageForCategory:(EventCategory)category
{
    NSString *categoryBigImageName = [[self class] categoryBigImageNameForCategory:category];
    UIImage *categoryBigImage = [UIImage imageNamed:categoryBigImageName];
    return categoryBigImage;
}


#pragma mark - Private methods

+ (NSString *)categoryKeyForCategory:(EventCategory)category
{
    switch (category) {
        case EventCategoryConcerts:
            return @"CATEGORY_CONCERTS";
        case EventCategoryNightlife:
            return @"Movies"; // TODO: Change back to CATEGORY_NIGHTLIFE
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


#pragma mark - Private methods

+ (NSString *)categoryImageNameForCategory:(EventCategory)category
{
    switch (category) {
        case EventCategoryConcerts:
            return @"Concerts";
        case EventCategoryNightlife:
            return @"Movies";  // TODO: Change to Other
        case EventCategoryTheatre:
            return @"Theatre";
//        case EventCategoryDance:
//            return @"Dance";
//        case EventCategoryArtExhibition:
//            return @"ArtExhibition";
//        case EventCategorySports:
//            return @"Sports";
        case EventCategoryPresentations:
            return @"Presentations";
        default:
            return @"Other";
    }
}

+ (NSString *)categoryBigImageNameForCategory:(EventCategory)category
{
    return [[self categoryImageNameForCategory:category] stringByAppendingString:@"-Big"];
}


@end
