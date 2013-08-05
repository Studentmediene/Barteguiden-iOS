//
//  EventFormatter+LocalizedText.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"
#import "EventKit.h"


@implementation EventFormatter (LocalizedText)

- (NSString *)currentLocalizedDescription
{
    NSString *currentLocalizedText = nil;
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    for (NSString *currentLanguage in preferredLanguages)
    {
        currentLocalizedText = [self.event descriptionForLanguage:currentLanguage];
        
        if (currentLocalizedText != nil) {
            break;
        }
    }
    
    return currentLocalizedText;
}

@end
