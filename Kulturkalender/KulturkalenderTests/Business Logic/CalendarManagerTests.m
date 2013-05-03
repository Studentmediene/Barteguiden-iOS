//
//  FilterManagerTests.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 03.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

// Class under test
#import "UserDefaultsCalendarManager.h"

// Collaborators
#import <EventKitUI/EventKitUI.h>

// Test support
#import <SenTestingKit/SenTestingKit.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


@interface CalendarManagerTests : SenTestCase
@end


@implementation CalendarManagerTests {
    id<CalendarManager> calendarManager;
    EKEventStore *calendarStoreMock;
    NSUserDefaults *userDefaultsMock;
}

- (void)setUp
{
    calendarStoreMock = mock([EKEventStore class]);
    userDefaultsMock = mock([NSUserDefaults class]);
    calendarManager = [[UserDefaultsCalendarManager alloc] initWithUserDefaults:userDefaultsMock calendarStore:calendarStoreMock];
}
 
- (void)tearDown
{
}


#pragma mark - Calendar store

- (void)testCalendarStoreIsReadable
{
    assertThat(calendarManager.calendarStore, is(equalTo(calendarStoreMock)));
}


#pragma mark - Auto-add favorites

- (void)testAutoAddFavoritesShouldReturnNoAsDefault
{
    [given([userDefaultsMock objectForKey:@"CalendarAutoAddFavorites"]) willReturn:nil];
    assertThatBool([calendarManager shouldAutoAddFavorites], is(equalToBool(NO)));
}

- (void)testAutoAddFavoritesShouldReturnValueStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"CalendarAutoAddFavorites"]) willReturn:@(YES)];
    assertThatBool([calendarManager shouldAutoAddFavorites], is(equalToBool(YES)));
}

- (void)testSetAutoAddFavoritesShouldSaveValueInUserDefaults
{
    [calendarManager setAutoAddFavorites:YES];
    [verify(userDefaultsMock) setObject:@YES forKey:@"CalendarAutoAddFavorites"];
}


#pragma mark - Default calendar

- (void)testDefaultCalendarShouldReturnCalendarStoresDefaultCalendarAsDefault
{
    EKCalendar *fakeCalendar = (EKCalendar *)[[NSObject alloc] init];
    
    [given([userDefaultsMock objectForKey:@"CalendarDefaultCalendarIdentifier"]) willReturn:nil];
    [given([calendarStoreMock defaultCalendarForNewEvents]) willReturn:fakeCalendar];
    assertThat([calendarManager defaultCalendar], is(equalTo(fakeCalendar)));
}

- (void)testDefaultCalendarShouldReturnCalendarStoredInUserDefaults
{
    EKCalendar *fakeCalendar = (EKCalendar *)[[NSObject alloc] init];
    NSString *fakeCalendarIdentifier = @"fakeID";
    
    [given([userDefaultsMock objectForKey:@"CalendarDefaultCalendarIdentifier"]) willReturn:fakeCalendarIdentifier];
    [given([calendarStoreMock calendarWithIdentifier:fakeCalendarIdentifier]) willReturn:fakeCalendar];
    assertThat([calendarManager defaultCalendar], is(equalTo(fakeCalendar)));
}

- (void)testDefaultCalendarShouldReturnDefaultCalendarWhenCalendarStoredInUserDefaultsDoesNotExist
{
    EKCalendar *fakeCalendar = (EKCalendar *)[[NSObject alloc] init];
    NSString *missingCalendarIdentifier = @"missingID";
    
    [given([userDefaultsMock objectForKey:@"CalendarDefaultCalendarIdentifier"]) willReturn:missingCalendarIdentifier];
    [given([calendarStoreMock calendarWithIdentifier:missingCalendarIdentifier]) willReturn:nil];
    [given([calendarStoreMock defaultCalendarForNewEvents]) willReturn:fakeCalendar];
    assertThat([calendarManager defaultCalendar], is(equalTo(fakeCalendar)));
}

- (void)testSetDefaultCalendarShouldSaveValueInUserDefaults
{
    NSString *fakeCalendarIdentifier = @"fakeID";
    EKCalendar *calendarMock = mock([EKCalendar class]);
    [given([calendarMock calendarIdentifier]) willReturn:fakeCalendarIdentifier];
    
    [calendarManager setDefaultCalendar:calendarMock];
    [verify(userDefaultsMock) setObject:fakeCalendarIdentifier forKey:@"CalendarDefaultCalendarIdentifier"];
}


#pragma mark - Default alert

- (void)testDefaultAlertShouldReturn30MinutesBeforeAsDefault
{
    [given([userDefaultsMock objectForKey:@"CalendarDefaultAlertTimeInterval"]) willReturn:nil];
    assertThatDouble([[calendarManager defaultAlert] relativeOffset], is(equalToDouble(30)));
}

- (void)testDefaultAlertShouldReturnValueStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"CalendarDefaultAlertTimeInterval"]) willReturn:@(5)];
    assertThatDouble([[calendarManager defaultAlert] relativeOffset], is(equalToDouble(5)));
}

- (void)testSetDefaultAlertTimeIntervalShouldSaveValueInUserDefaults
{
    [calendarManager setDefaultAlertTimeInterval:11];
    [verify(userDefaultsMock) setObject:@11 forKey:@"CalendarDefaultAlertTimeInterval"];
}

- (void)testSetDefaultAlertShouldSaveValueInUserDefaults
{
    EKAlarm *alert = [EKAlarm alarmWithRelativeOffset:12];
    [calendarManager setDefaultAlert:alert];
    [verify(userDefaultsMock) setObject:@12 forKey:@"CalendarDefaultAlertTimeInterval"];
}

@end
