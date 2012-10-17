//
//  Event+Custom.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Custom.h"
#import "LocalizedText.h"

@implementation Event (Custom)

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

// TODO: Fix and remembere localization
- (NSString *)timeString
{
    return [self.timeStartAt description];
}

// TODO: Fix and remembere localization
- (NSString *)categoryString
{
    return [self.category stringValue];
}

// TODO: Fix and remembere localization
- (NSString *)priceString
{
    return [NSString stringWithFormat:@"NOK %@", self.price];
}

// TODO: Fix and remembere localization
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

@end

#pragma mark - Constants

NSString * const kEventSectionName = @"dateSectionName";