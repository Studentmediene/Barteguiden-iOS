//
//  EventBuilder.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventBuilder.h"
#import "Event.h"
#import "LocalizedText.h"
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
    
    [event setValue:jsonObject[@"id"] forKey:@"eventID"];
    event.featuredState = @(jsonObject[@"featured"] != nil);
    event.ageLimitNumber = jsonObject[@"ageLimit"];
    
    NSString *categoryString = jsonObject[@"categoryID"];
    NSNumber *categoryID = [[self categoriesByKey] objectForKey:categoryString];
    if (categoryID != nil) {
        event.categoryID = categoryID;
    }

    event.localizedDescription = [self setWithLocalizedTextForEntityName:kLocalizedDescriptionEntityName withJSONObject:jsonObject[@"description"] inManagedObjectContext:event.managedObjectContext];
    event.localizedFeatured = [self setWithLocalizedTextForEntityName:kLocalizedFeaturedEntityName withJSONObject:jsonObject[@"featured"] inManagedObjectContext:event.managedObjectContext];
}

- (NSSet *)setWithLocalizedTextForEntityName:(NSString *)entityName withJSONObject:(NSArray *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (NSDictionary *text in jsonObject) {
        LocalizedText *localizedText = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
        
        [localizedText safeSetValuesForKeysWithDictionary:text dateFormatter:nil];
        
        [set addObject:localizedText];
    }
    
    return set;
}


#pragma mark - Private methods

+ (NSDateFormatter *)jsonDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    
    return dateFormatter;
}

- (NSDictionary *)categoriesByKey
{
    static NSDictionary *categories;
    if (categories == nil) {
        categories = @{@"OTHER": @(EventCategoryOther),
                       @"CONCERTS": @(EventCategoryConcerts),
                       @"NIGHTLIFE": @(EventCategoryNightlife),
                       @"THEATRE": @(EventCategoryTheatre),
                       @"DANCE": @(EventCategoryDance),
                       @"ART_EXHIBITION": @(EventCategoryArtExhibition),
                       @"SPORTS": @(EventCategorySports),
                       @"PRESENTATIONS": @(EventCategoryPresentations)};
    }
    
    return categories;
}

@end
