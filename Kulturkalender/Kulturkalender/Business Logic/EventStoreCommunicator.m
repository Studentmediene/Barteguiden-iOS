//
//  EventStoreCommunicator.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreCommunicator.h"

@implementation EventStoreCommunicator

- (NSURL *)URLForEventChangesSince:(NSDate *)since
{
    NSParameterAssert(since != nil);
    NSTimeInterval timeInterval = [since timeIntervalSince1970];
    NSString *changesPath = [NSString stringWithFormat:@"events/changes?since=%.0f", timeInterval];
    return [NSURL URLWithString:changesPath relativeToURL:[self baseURL]];
}

- (NSURL *)URLForImageWithEventID:(NSString *)eventID
{
    NSParameterAssert(eventID != nil);
    NSString *imagePath = [NSString stringWithFormat:@"events/%@.png", eventID];
    return [NSURL URLWithString:imagePath relativeToURL:[self baseURL]];
}

#pragma mark - Private methods

- (NSURL *)baseURL
{
    return [NSURL URLWithString:@"http://skohorn.net:3000/v1/"];
}

@end
