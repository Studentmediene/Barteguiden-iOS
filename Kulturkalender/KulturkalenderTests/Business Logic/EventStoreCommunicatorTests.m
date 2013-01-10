//
//  EventStoreCommunicatorTests.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreCommunicatorTests.h"
#import "EventStoreCommunicator.h"

@implementation EventStoreCommunicatorTests {
    EventStoreCommunicator *communicator;
}

- (void)setUp
{
    communicator = [[EventStoreCommunicator alloc] init];
}

- (void)tearDown
{
}


#pragma mark - Tests

- (void)testURLForEventChanges
{
    NSDate *since = [NSDate dateWithTimeIntervalSince1970:123456];
    STAssertEqualObjects([[communicator URLForEventChangesSince:since] absoluteString], @"http://skohorn.net:3000/v1/events/changes?since=123456", @"URL should match the expected URL.");
}

- (void)testURLForImageWithEventID
{
    STAssertEqualObjects([[communicator URLForImageWithEventID:@"EVENT_ID"] absoluteString], @"http://skohorn.net:3000/v1/events/EVENT_ID.png", @"URL should match the expected URL.");
}

@end
