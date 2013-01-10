//
//  EventStoreCommunicator.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventStoreCommunicator : NSObject

- (NSURL *)URLForEventChangesSince:(NSDate *)since;
- (NSURL *)URLForImageWithEventID:(NSString *)eventID;

@end
