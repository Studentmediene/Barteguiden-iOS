//
//  EventBuilder.m
//  Kulturkalender
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
    event.featuredState = jsonObject[@"featured"];
    event.favoriteState = jsonObject[@"favorite"];
    
    // Add localized description
    NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
    NSArray *descriptions = jsonObject[@"localizedDescription"];
    for (NSDictionary *description in descriptions) {
        NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:kLocalizedDescriptionEntityName inManagedObjectContext:[event managedObjectContext]];
        [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:dateFormatter];
        
        [descriptionSet addObject:managedDescription];
    }
    event.localizedDescription = descriptionSet;
    
    // Add localized featured
    NSMutableSet *featuredSet = [[NSMutableSet alloc] init];
    NSArray *featureds = jsonObject[@"localizedFeatured"];
    for (NSDictionary *featured in featureds) {
        NSManagedObject *managedFeatured = [NSEntityDescription insertNewObjectForEntityForName:kLocalizedFeaturedEntityName inManagedObjectContext:[event managedObjectContext]];
        [managedFeatured safeSetValuesForKeysWithDictionary:featured dateFormatter:dateFormatter];
        
        [featuredSet addObject:managedFeatured];
    }
    event.localizedFeatured = featuredSet;
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

@end
