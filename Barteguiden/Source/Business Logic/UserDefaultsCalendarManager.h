//
//  UserDefaultsCalendarManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarManager.h"

@interface UserDefaultsCalendarManager : NSObject <CalendarManager>

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults calendarStore:(EKEventStore *)calendarStore;

- (void)save;

// Defaults
- (void)registerDefaultAutoAddFavorites:(BOOL)autoAddFavorites;
- (void)registerDefaultDefaultCalendarIdentifier:(NSString *)defaultCalendarIdentifier;
- (void)registerDefaultDefaultAlertTimeInterval:(NSTimeInterval)defaultAlertTimeInterval;

@end
