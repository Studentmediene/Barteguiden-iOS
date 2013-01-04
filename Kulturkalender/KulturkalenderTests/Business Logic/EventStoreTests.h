//
//  EventStoreTests.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@protocol EventStore;

@interface EventStoreTests : SenTestCase

@property (nonatomic, strong) id<EventStore> eventStore;

@end
