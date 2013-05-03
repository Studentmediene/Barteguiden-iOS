//
//  CalendarManager.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

@protocol CalendarManagerDelegate;
@class EKCalendar;
@class EKEventStore;


@protocol CalendarManager <NSObject>

@property (nonatomic, strong) EKEventStore *calendarStore;

// Settings
@property (nonatomic) BOOL autoAddFavorites;
@property (nonatomic, strong) EKCalendar *defaultCalendar;
//@property (nonatomic, strong) <#type *object#>;

@end
