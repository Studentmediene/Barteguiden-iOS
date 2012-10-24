//
//  Event+Custom.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Custom.h"
#import "LocalizedText.h"
#import "Location.h"
#import "NSManagedObject+CIMGF.h"

@implementation Event (Custom)

+ (id)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSDateFormatter *dateFormatter = [[self class] jsonDateFormatter];
    
    // Create event
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [event safeSetValuesForKeysWithDictionary:jsonObject dateFormatter:dateFormatter];
    event.timeCreatedAt = [NSDate date];
    
    // Add location
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [location safeSetValuesForKeysWithDictionary:[jsonObject objectForKey:@"location"] dateFormatter:dateFormatter];
    event.location = location;
    
    // Add localized description
    NSMutableSet *descriptionSet = [[NSMutableSet alloc] init];
    NSArray *descriptions = [jsonObject objectForKey:@"localizedDescription"];
    for (NSDictionary *description in descriptions) {
        NSManagedObject *managedDescription = [NSEntityDescription insertNewObjectForEntityForName:@"LocalizedDescription" inManagedObjectContext:managedObjectContext];
        [managedDescription safeSetValuesForKeysWithDictionary:description dateFormatter:dateFormatter];
        
        [descriptionSet addObject:managedDescription];
    }
    event.localizedDescription = descriptionSet;
    
    // Add localized featured
    NSMutableSet *featuredSet = [[NSMutableSet alloc] init];
    NSArray *featureds = [jsonObject objectForKey:@"localizedFeatured"];
    for (NSDictionary *featured in featureds) {
        NSManagedObject *managedFeatured = [NSEntityDescription insertNewObjectForEntityForName:@"LocalizedFeatured" inManagedObjectContext:managedObjectContext];
        [managedFeatured safeSetValuesForKeysWithDictionary:featured dateFormatter:dateFormatter];
        
        [featuredSet addObject:managedFeatured];
    }
    event.localizedFeatured = featuredSet;
    
    return event;
}

- (NSString *)dateSectionName
{
    // Set date formatter
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    });
    
    // Get section name
    NSString *sectionName = [dateFormatter stringFromDate:self.timeStartAt];
    return sectionName;
}

// TODO: Fix and remember localization
- (NSString *)timeAndLocationString
{
    // Set date formatter
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    
    NSString *timeAndLocation = [NSString stringWithFormat:@"%@ at %@", [dateFormatter stringFromDate:self.timeStartAt], self.location.placeName];
    
    return timeAndLocation;
}

// TODO: Fix and remember localization
- (NSString *)timeString
{
    return [self.timeStartAt description];
}

// TODO: Fix and remember localization
- (NSString *)categoryString
{
    return [self.category stringValue];
}

// TODO: Fix and remember localization
- (NSString *)priceString
{
    if ([self.price isEqualToNumber:@0]) {
        return @"Free";
    }
    return [NSString stringWithFormat:@"%@kr", self.price];
}

// TODO: Fix and remember localization
- (NSString *)ageLimitString
{
    return [NSString stringWithFormat:@"%@ and above", self.ageLimit];
}

- (NSString *)currentLocalizedDescription
{
    return [self currentLocalizedTextFromSet:self.localizedDescription];
}

- (NSString *)currentLocalizedFeatured
{
    return [self currentLocalizedTextFromSet:self.localizedFeatured];
}

#pragma mark - Private methods

- (NSString *)localizedTextFromSet:(NSSet *)set withLanguage:(NSString *)language
{
    NSSet *currentLocalizedTexts = [set objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        LocalizedText *localizedText = obj;
        if ([localizedText.language isEqualToString:language]) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    return [[currentLocalizedTexts anyObject] text];
}

- (NSString *)currentLocalizedTextFromSet:(NSSet *)set
{
    NSString *currentLocalizedText = nil;
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    for (NSString *currentLanguage in preferredLanguages)
    {
        currentLocalizedText = [self localizedTextFromSet:set withLanguage:currentLanguage];
        
        if (currentLocalizedText != nil) {
            break;
        }
    }
    
    return currentLocalizedText;
}

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

#pragma mark - Constants

NSString * const kEventSectionName = @"dateSectionName";