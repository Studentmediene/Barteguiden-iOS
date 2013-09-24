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


@implementation EventBuilder

- (Event *)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (jsonObject == nil) {
        return nil;
    }
    
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:managedObjectContext];
    
    [self updateEvent:event withJSONObject:jsonObject];
    
    if ([event validateForInsert:NULL] == NO) {
        [managedObjectContext deleteObject:event];
        return nil;
    }
    
    return event;
}

- (BOOL)updateEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (jsonObject == nil) {
        return NO;
    }
    
    [self updateEvent:event withJSONObject:jsonObject];
    
    if ([event validateForUpdate:NULL] == NO) {
        [managedObjectContext refreshObject:event mergeChanges:NO];
        return NO;
    }
    
    return YES;
}


#pragma mark - Private methods

- (void)updateEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject
{
    NSDateFormatter *dateFormatter = [[self class] jsonDateFormatter];
    
    [event safeSetValuesForKeysWithDictionary:jsonObject dateFormatter:dateFormatter];
    
    [event safeSetValue:jsonObject[@"isRecommended"] forKey:@"featuredState"];
    
    [self updateCategoryIDInEvent:event withJSONObject:jsonObject];
    
    [self updateDescriptionsInEvent:event withJSONObject:jsonObject];
}

- (void)updateCategoryIDInEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject
{
    NSNumber *category = nil;
    id categoryID = jsonObject[@"categoryID"];
    if ([categoryID isKindOfClass:[NSString class]]) {
        category = [[self categoriesByKey] objectForKey:categoryID];
    }
    
    [event safeSetValue:category forKey:@"categoryID"];
}

- (void)updateDescriptionsInEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject
{
    id description_nb = [NSNull null];
    id description_en = [NSNull null];
    
    id descriptions = jsonObject[@"descriptions"];
    if ([descriptions isKindOfClass:[NSArray class]]) {
        for (NSDictionary *description in descriptions) {
            id language = description[@"language"];
            id text = description[@"text"];
            
            if ([language isKindOfClass:[NSString class]] == NO || [text isKindOfClass:[NSString class]] == NO) {
                continue;
            }
            
            if ([language isEqualToString:@"nb"]) {
                description_nb = text;
            }
            else if ([language isEqualToString:@"en"]) {
                description_en = text;
            }
        }
    }
    
    [event safeSetValue:description_nb forKey:@"description_nb"];
    [event safeSetValue:description_en forKey:@"description_en"];
}

+ (NSDateFormatter *)jsonDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
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
