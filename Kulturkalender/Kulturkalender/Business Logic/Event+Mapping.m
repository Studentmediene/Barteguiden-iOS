//
//  Event+Mapping.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Mapping.h"
#import "Event+Location.h"
#import "EventConstants.h"
#import <NSManagedObject+CIMGF_SafeSetValuesForKeysWithDictionary.h>

@implementation Event (Mapping)

+ (id)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSDateFormatter *dateFormatter = [[self class] jsonDateFormatter];
    
    // TODO: Implement for the real server
    
    // Create event
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:eventEntityName inManagedObjectContext:managedObjectContext];
    [event safeSetValuesForKeysWithDictionary:jsonObject dateFormatter:dateFormatter];
    
    // Add localized description
    NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
    NSArray *descriptions = jsonObject[@"localizedDescription"];
    for (NSDictionary *description in descriptions) {
        NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:localizedDescriptionEntityName inManagedObjectContext:managedObjectContext];
        [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:dateFormatter];
        
        [descriptionSet addObject:managedDescription];
    }
    event.localizedDescription = descriptionSet;
    
    // Add localized featured
    NSMutableSet *featuredSet = [[NSMutableSet alloc] init];
    NSArray *featureds = jsonObject[@"localizedFeatured"];
    for (NSDictionary *featured in featureds) {
        NSManagedObject *managedFeatured = [NSEntityDescription insertNewObjectForEntityForName:localizedFeaturedEntityName inManagedObjectContext:managedObjectContext];
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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    });
    
    return dateFormatter;
}

@end
