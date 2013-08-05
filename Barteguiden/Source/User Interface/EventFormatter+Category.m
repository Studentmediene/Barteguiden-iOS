//
//  EventFormatter+Category.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Category.h"


@implementation EventFormatter (Category)

- (NSString *)categoryString
{
    return [[self class] categoryStringForCategory:[self.event category]];
}

+ (NSString *)categoryStringForCategory:(EventCategory)category
{
    NSString *categoryKey = [[self class] categoryKeyForCategory:category];
    NSString *categoryString = NSLocalizedStringFromTable(categoryKey, @"Event", @"The category for an event");
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
        case EventCategoryMusic:
            return @"CATEGORY_MUSIC";
        case EventCategoryNightlife:
            return @"CATEGORY_NIGHTLIFE";
        case EventCategorySport:
            return @"CATEGORY_SPORT";
        case EventCategoryPerformances:
            return @"CATEGORY_PERFORMANCES";
        case EventCategoryPresentations:
            return @"CATEGORY_PRESENTATIONS";
        case EventCategoryExhibitions:
            return @"CATEGORY_EXHIBITIONS";
        case EventCategoryDebate:
            return @"CATEGORY_DEBATE";
        default:
            return @"CATEGORY_OTHER";
    }
}


#pragma mark - Private methods

+ (NSString *)categoryImageNameForCategory:(EventCategory)category
{
    switch (category) {
        case EventCategoryMusic:
            return @"CategoryMusic";
        case EventCategoryNightlife:
            return @"CategoryNightlife";
        case EventCategorySport:
            return @"CategorySport";
        case EventCategoryPerformances:
            return @"CategoryPerformances";
        case EventCategoryPresentations:
            return @"CategoryPresentations";
        case EventCategoryExhibitions:
            return @"CategoryExhibitions";
        case EventCategoryDebate:
            return @"CategoryDebate";
        default:
            return @"CategoryOther";
    }
}

+ (NSString *)categoryBigImageNameForCategory:(EventCategory)category
{
    return [[self categoryImageNameForCategory:category] stringByAppendingString:@"-Big"];
}


@end
