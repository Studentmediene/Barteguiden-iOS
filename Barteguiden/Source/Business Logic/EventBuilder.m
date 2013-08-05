//
//  EventBuilder.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventBuilder.h"
#import "Event.h"
#import "NSManagedObject+CIMGFSafeSetValuesForKeysWithDictionary.h"


static NSString * const kEventEntityName = @"Event";
static NSString * const kLocalizedDescriptionEntityName = @"LocalizedDescription";
static NSString * const kLocalizedFeaturedEntityName = @"LocalizedFeatured";


@implementation EventBuilder

- (Event *)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:managedObjectContext];
    [self updateEvent:event withJSONObject:jsonObject];
    
    return event;
}

- (void)updateEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject
{
    // TODO: Implement for the real server
    
    NSDateFormatter *dateFormatter = [[self class] jsonDateFormatter];
    
    [event safeSetValuesForKeysWithDictionary:jsonObject dateFormatter:dateFormatter];
    
    event.featuredState = @([jsonObject[@"isRecommended"] boolValue]);
    
    NSString *categoryString = jsonObject[@"categoryID"];
    NSNumber *categoryID = [[self categoriesByKey] objectForKey:categoryString];
    if (categoryID != nil) {
        event.categoryID = categoryID;
    }
    
    NSArray *descriptions = jsonObject[@"descriptions"];
    if (descriptions != nil) {
        for (NSDictionary *description in descriptions) {
            if ([description[@"language"] isEqualToString:@"nb"]) {
                event.description_nb = description[@"text"];
            }
            else if ([description[@"language"] isEqualToString:@"en"]) {
                event.description_en = description[@"text"];
            }
        }
    }
}


#pragma mark - Private methods

+ (NSDateFormatter *)jsonDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.sssZ"];
    }
    
    return dateFormatter;
}

- (NSDictionary *)categoriesByKey
{
    static NSDictionary *categories;
    if (categories == nil) {
        categories = @{@"OTHER": @(EventCategoryOther),
                       @"MUSIC": @(EventCategoryMusic),
                       @"NIGHTLIFE": @(EventCategoryNightlife),
                       @"SPORT": @(EventCategorySport),
                       @"PERFORMANCES": @(EventCategoryPerformances),
                       @"PRESENTATIONS": @(EventCategoryPresentations),
                       @"EXHIBITIONS": @(EventCategoryExhibitions),
                       @"DEBATE": @(EventCategoryDebate)};
    }
    
    return categories;
}

@end
