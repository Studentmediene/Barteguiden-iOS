//
//  EventBuilderTests.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 19.08.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

// Class under test
#import "EventBuilder.h"

// Collaborators

// Test support
#import <SenTestingKit/SenTestingKit.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>


@interface EventBuilderTests : SenTestCase
@end


@implementation EventBuilderTests {
    
}

- (void)setUp
{
}

- (void)tearDown
{
}


#pragma mark - Tests

- (void)testFail
{
    STFail(@"This should fail");
}

@end
