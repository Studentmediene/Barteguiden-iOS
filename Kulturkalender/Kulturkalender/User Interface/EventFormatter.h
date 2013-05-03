//
//  EventFormatter.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Event;

@interface EventFormatter : NSObject

@property (nonatomic, strong, readonly) id<Event> event;
@property (nonatomic, strong) NSLocale *locale;

- (instancetype)initWithEvent:(id<Event>)event;

@end
