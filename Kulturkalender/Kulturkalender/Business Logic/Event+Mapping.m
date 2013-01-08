//
//  Event+Mapping.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Mapping.h"


static NSString * const kEventEntityName = @"Event";
static NSString * const kLocalizedDescriptionEntityName = @"LocalizedDescription";
static NSString * const kLocalizedFeaturedEntityName = @"LocalizedFeatured";


@implementation ManagedEvent (Mapping)

+ (instancetype)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSDateFormatter *dateFormatter = [[self class] jsonDateFormatter];
    
    // TODO: Implement for the real server
    
    // Create event
    ManagedEvent *event = [NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:managedObjectContext];
    [event safeSetValuesForKeysWithDictionary:jsonObject dateFormatter:dateFormatter];
    
    // Add localized description
    NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
    NSArray *descriptions = jsonObject[@"localizedDescription"];
    for (NSDictionary *description in descriptions) {
        NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:kLocalizedDescriptionEntityName inManagedObjectContext:managedObjectContext];
        [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:dateFormatter];
        
        [descriptionSet addObject:managedDescription];
    }
    event.localizedDescription = descriptionSet;
    
    // Add localized featured
    NSMutableSet *featuredSet = [[NSMutableSet alloc] init];
    NSArray *featureds = jsonObject[@"localizedFeatured"];
    for (NSDictionary *featured in featureds) {
        NSManagedObject *managedFeatured = [NSEntityDescription insertNewObjectForEntityForName:kLocalizedFeaturedEntityName inManagedObjectContext:managedObjectContext];
        [managedFeatured safeSetValuesForKeysWithDictionary:featured dateFormatter:dateFormatter];
        
        [featuredSet addObject:managedFeatured];
    }
    event.localizedFeatured = featuredSet;
    
    return event;
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
