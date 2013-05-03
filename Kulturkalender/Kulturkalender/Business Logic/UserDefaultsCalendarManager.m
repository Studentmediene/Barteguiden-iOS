//
//  UserDefaultsCalendarManager.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "UserDefaultsCalendarManager.h"
#import <EventKit/EventKit.h>


@interface UserDefaultsCalendarManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation UserDefaultsCalendarManager

@synthesize calendarStore=_calendarStore;
@synthesize autoAddFavorites=_autoAddFavorites;
@synthesize defaultCalendar=_defaultCalendar;


- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults calendarStore:(EKEventStore *)calendarStore
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
        _calendarStore = calendarStore;
    }
    return self;
}

@end
