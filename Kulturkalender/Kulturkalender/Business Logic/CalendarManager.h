//
//  CalendarManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

@protocol CalendarManagerDelegate;
@class EKEventStore;
@class EKCalendar;
@class EKAlarm;


@protocol CalendarManager <NSObject>

@property (nonatomic, readonly) EKEventStore *calendarStore;

// Settings
@property (nonatomic, getter=shouldAutoAddFavorites) BOOL autoAddFavorites;
@property (nonatomic, strong) EKCalendar *defaultCalendar;
@property (nonatomic, strong) EKAlarm *defaultAlert;

@end
