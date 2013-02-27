//
//  EventStoreCommunicatorDelegate.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 25.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EventStoreCommunicator;

@protocol EventStoreCommunicatorDelegate <NSObject>

- (void)communicator:(EventStoreCommunicator *)communicator didReceiveEventChangesWithInserted:(NSArray *)inserted updated:(NSArray *)updated deleted:(NSArray *)deleted;
- (void)communicator:(EventStoreCommunicator *)communicator didFailWithError:(NSError *)error;

@end
