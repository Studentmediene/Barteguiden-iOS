//
//  EventBuilder.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface EventBuilder : NSObject

- (Event *)insertNewEventWithJSONObject:(NSDictionary *)jsonObject inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)updateEvent:(Event *)event withJSONObject:(NSDictionary *)jsonObject;

@end
