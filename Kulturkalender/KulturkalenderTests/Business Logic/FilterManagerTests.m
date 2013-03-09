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
    FilterManager *filterManager;
    NSUserDefaults *userDefaultsMock;
}

- (void)setUp
{
    userDefaultsMock = mock([NSUserDefaults class]);
    filterManager = [[FilterManager alloc] initWithUserDefaults:userDefaultsMock eventStore:nil];
}
 
- (void)tearDown
{
}


#pragma mark - Defaults

// TODO: Missing
// TODO: Also test predicate?


#pragma mark - Category filter

- (void)testCategoryFilterShouldDefaultToNSUIntegerMax
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturnUnsignedInteger:NSUIntegerMax];
    assertThatUnsignedInteger([filterManager categoryFilter], is(equalToUnsignedInteger(NSUIntegerMax)));
}

- (void)testCategoryFilterShouldReturnNumberStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@3];
    assertThatUnsignedInteger([filterManager categoryFilter], is(equalToUnsignedInteger(3)));
}

- (void)testCategoryFilterShouldSaveNumberInUserDefaults
{
    [filterManager setCategoryFilter:7];
    [verify(userDefaultsMock) setObject:@7 forKey:@"CategoryFilterSelection"];
}

- (void)testIsSelectedForCategoryShouldReturnNoForEmptyCategoryFilter
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@0];
    assertThatBool([filterManager isSelectedForCategory:0], is(equalToBool(NO)));
}

- (void)testIsSelectedForCategoryShouldReturnYesForNightlife
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@2];
    assertThatBool([filterManager isSelectedForCategory:1], is(equalToBool(YES)));
}

- (void)testIsSelectedForCategoryShouldReturnYesForDance
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@8];
    assertThatBool([filterManager isSelectedForCategory:3], is(equalToBool(YES)));
}

- (void)testSetSelectedForCategoryShouldSelectNightlifeWhenNoneIsSelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@0];
    [filterManager setSelected:YES forCategory:1];
    [verify(userDefaultsMock) setObject:@(2) forKey:@"CategoryFilterSelection"];
}

- (void)testSetSelectedForCategoryShouldSelectNightlifeWhenConcertsIsAlreadySelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@1];
    [filterManager setSelected:YES forCategory:1];
    [verify(userDefaultsMock) setObject:@(3) forKey:@"CategoryFilterSelection"];
}

- (void)testSetSelectedForCategoryShouldSelectDanceWhenConcertsIsAlreadySelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@1];
    [filterManager setSelected:YES forCategory:3];
    [verify(userDefaultsMock) setObject:@(9) forKey:@"CategoryFilterSelection"];
}

- (void)testSetSelectedForCategoryShouldDeselectConcertsWhenThreeFirstCategoriesAreSelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@(7)];
    [filterManager setSelected:NO forCategory:0];
    [verify(userDefaultsMock) setObject:@(6) forKey:@"CategoryFilterSelection"];
}

- (void)testSetSelectedForCategoryShouldDeselectNightlifeWheThreeFirstCategoriesAreSelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@7];
    [filterManager setSelected:NO forCategory:1];
    [verify(userDefaultsMock) setObject:@(5) forKey:@"CategoryFilterSelection"];
}

- (void)testToggleSelectedForCategoryShouldSelectTheatreWhenNoneIsSelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@0];
    [filterManager toggleSelectedForCategory:2];
    [verify(userDefaultsMock) setObject:@(4) forKey:@"CategoryFilterSelection"];
}

- (void)testToggleSelectedForCategoryShouldDeselectTheatreWhenTheatreIsSelected
{
    [given([userDefaultsMock objectForKey:@"CategoryFilterSelection"]) willReturn:@4];
    [filterManager toggleSelectedForCategory:2];
    [verify(userDefaultsMock) setObject:@(0) forKey:@"CategoryFilterSelection"];
}


#pragma mark - Age limit filter

- (void)testAgeLimitFilterShouldDefaultToZero
{
    [given([userDefaultsMock objectForKey:@"AgeLimitFilterSelection"]) willReturn:nil];
    assertThatInteger([filterManager ageLimitFilter], is(equalToInteger(0)));
}

- (void)testAgeLimitFilterShouldReturnNumberStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"AgeLimitFilterSelection"]) willReturn:@5];
    assertThatInteger([filterManager ageLimitFilter], is(equalToInteger(5)));
}

- (void)testSetAgeLimitFilterShouldSaveNumberInUserDefaults
{
    [filterManager setAgeLimitFilter:6];
    [verify(userDefaultsMock) setObject:@6 forKey:@"AgeLimitFilterSelection"];
}

- (void)testMyAgeShouldDefaultToZero
{
    [given([userDefaultsMock objectForKey:@"AgeLimitFilterMyAge"]) willReturn:nil];
    assertThatUnsignedInteger([filterManager myAge], is(equalToUnsignedInteger(0)));
}

- (void)testMyAgeShouldReturnNumberStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"AgeLimitFilterMyAge"]) willReturn:@5];
    assertThatUnsignedInteger([filterManager myAge], is(equalToUnsignedInteger(5)));
}

- (void)testSetMyAgeShouldSaveNumberInUserDefaults
{
    [filterManager setMyAge:6];
    [verify(userDefaultsMock) setObject:@6 forKey:@"AgeLimitFilterMyAge"];
}

- (void)testSetMyAgeToZeroShouldSaveZeroInUserDefaults
{
    [filterManager setMyAge:0];
    [verify(userDefaultsMock) setObject:@(0) forKey:@"AgeLimitFilterMyAge"];
}


#pragma mark - Price filter

- (void)testPriceFilterShouldDefaultToZero
{
    [given([userDefaultsMock objectForKey:@"PriceFilterSelection"]) willReturn:nil];
    assertThatInteger([filterManager priceFilter], is(equalToInteger(0)));
}

- (void)testPriceFilterShouldReturnNumberStoredInUserDefaults
{
    [given([userDefaultsMock objectForKey:@"PriceFilterSelection"]) willReturn:@5];
    assertThatInteger([filterManager priceFilter], is(equalToInteger(5)));
}

- (void)testSetPriceFilterShouldSaveNumberInUserDefaults
{
    [filterManager setPriceFilter:6];
    [verify(userDefaultsMock) setObject:@6 forKey:@"PriceFilterSelection"];
}


#pragma mark - Saving

- (void)testSaveShouldPersistUserDefaults
{
    [filterManager save];
    [verify(userDefaultsMock) synchronize];
}

@end
