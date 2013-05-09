//
//  CalendarManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

@protocol CalendarManagerDelegate;
@class EKEventStore;
@class EKEvent;
@class EKCalendar;
@class EKAlarm;


@protocol CalendarManager <NSObject>

@property (nonatomic, readonly) EKEventStore *calendarStore;

- (EKEvent *)newCalendarEvent;

// Authorization
- (void)requestAccessWithCompletion:(void (^)(void))completion;

// Settings
@property (nonatomic, getter=shouldAutoAddFavorites) BOOL autoAddFavorites;
@property (nonatomic, strong) EKCalendar *defaultCalendar;
@property (nonatomic, strong) EKAlarm *defaultAlert;

@end


// Errors
extern NSString * const CalendarManagerErrorDomain;

typedef NS_ENUM(NSInteger, CalendarManagerErrorCode) {
    CalendarManagerAuthorizationFailed = 0,
};

// Notifications
extern NSString * const CalendarManagerDidFailNotification;

// User info keys
extern NSString * const CalendarManagerErrorUserInfoKey;