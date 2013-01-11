//
//  FilterManagerTests.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 11.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

// Class under test
#import "FilterManager.h"

// Collaborators


// Test support
#import <SenTestingKit/SenTestingKit.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


@interface FilterManagerTests : SenTestCase
@end


@implementation FilterManagerTests {
    FilterManager *_filterManager;
    NSUserDefaults *_userDefaultsMock;
}

- (void)setUp
{
    _userDefaultsMock = mock([NSUserDefaults class]);
    _filterManager = [[FilterManager alloc] initWithUserDefaults:_userDefaultsMock];
}
 
- (void)tearDown
{
}


#pragma mark - Defaults

// TODO: Missing


#pragma mark - Category filter

//- (void)testIsSelectedForCategoryIDShouldABC
//{
//    
//}


#pragma mark - Age limit filter

- (void)testAgeLimitFilterShouldDefaultToZero
{
    [given([_userDefaultsMock objectForKey:@"AgeLimitFilterSelection"]) willReturn:nil];
    
    assertThatInteger([_filterManager ageLimitFilter], is(equalToInteger(0)));
}

- (void)testAgeLimitFilterShouldReturnNumberStoredInUserDefaults
{
    [given([_userDefaultsMock objectForKey:@"AgeLimitFilterSelection"]) willReturn:@5];
    
    assertThatInteger([_filterManager ageLimitFilter], is(equalToInteger(5)));
}

- (void)testSetAgeLimitFilterShouldSaveNumberInUserDefaults
{
    [_filterManager setAgeLimitFilter:6];
    [verify(_userDefaultsMock) setObject:@6 forKey:@"AgeLimitFilterSelection"];
}

- (void)testMyAgeShouldDefaultToNil
{
    [given([_userDefaultsMock objectForKey:@"AgeLimitFilterMyAge"]) willReturn:nil];
    assertThat([_filterManager myAge], is(equalTo(nil)));
}

- (void)testMyAgeShouldReturnNumberStoredInUserDefaults
{
    [given([_userDefaultsMock objectForKey:@"AgeLimitFilterMyAge"]) willReturn:@5];
    assertThat([_filterManager myAge], is(equalTo(@5)));
}

- (void)testSetMyAgeShouldSaveNumberInUserDefaults
{
    [_filterManager setMyAge:@6];
    [verify(_userDefaultsMock) setObject:@6 forKey:@"AgeLimitFilterMyAge"];
}

- (void)testSetMyAgeToZeroShouldSaveNilInUserDefaults
{
    [_filterManager setMyAge:@0];
    [verify(_userDefaultsMock) setObject:nil forKey:@"AgeLimitFilterMyAge"];
}


#pragma mark - Price filter

- (void)testPriceFilterShouldDefaultToZero
{
    [given([_userDefaultsMock objectForKey:@"PriceFilterSelection"]) willReturn:nil];
    assertThatInteger([_filterManager priceFilter], is(equalToInteger(0)));
}

- (void)testPriceFilterShouldReturnNumberStoredInUserDefaults
{
    [given([_userDefaultsMock objectForKey:@"PriceFilterSelection"]) willReturn:@5];
    assertThatInteger([_filterManager priceFilter], is(equalToInteger(5)));
}

- (void)testSetPriceFilterShouldSaveNumberInUserDefaults
{
    [_filterManager setPriceFilter:6];
    [verify(_userDefaultsMock) setObject:@6 forKey:@"PriceFilterSelection"];
}


#pragma mark - Saving

- (void)testSaveShouldPersistUserDefaults
{
    [_filterManager save];
    [verify(_userDefaultsMock) synchronize];
}

@end
