//
//  Event+Custom.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event.h"

@interface Event (Custom)

- (NSString *)dateSectionName;

- (NSString *)timeAndLocationString;
- (NSString *)timeString;
- (NSString *)categoryString;
- (NSString *)priceString;
- (NSString *)ageLimitString;

- (NSString *)currentLocalizedDescription;
- (NSString *)currentLocalizedFeatured;

@end

// Constants
extern NSString * const kEventSectionName;