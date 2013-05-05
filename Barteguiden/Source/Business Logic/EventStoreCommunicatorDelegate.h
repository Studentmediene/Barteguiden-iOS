//
//  EventStoreCommunicatorDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 25.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EventStoreCommunicator;

@protocol EventStoreCommunicatorDelegate <NSObject>

- (void)communicator:(EventStoreCommunicator *)communicator didReceiveEvents:(NSArray *)events;
- (void)communicator:(EventStoreCommunicator *)communicator didFailWithError:(NSError *)error;

@end
