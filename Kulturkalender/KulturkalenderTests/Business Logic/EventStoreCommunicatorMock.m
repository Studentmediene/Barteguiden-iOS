//
//  EventStoreCommunicatorMock.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 27.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreCommunicatorMock.h"

@implementation EventStoreCommunicatorMock

- (void)startDownloadWithURLRequest:(NSURLRequest *)urlRequest
{
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    if (error == nil) {
        [self notifyDidFinishLoadingWithData:data];
    }
    else {
        [self notifyDidFailWithError:error];
    }
}

- (NSURL *)URLForEvents
{
    return [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"]; // TODO: Use correct file
}

@end
