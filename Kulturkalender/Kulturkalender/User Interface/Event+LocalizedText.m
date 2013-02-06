//
//  Event+LocalizedText.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+LocalizedText.h"
#import "LocalizedText.h"

@implementation Event (LocalizedText)

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
