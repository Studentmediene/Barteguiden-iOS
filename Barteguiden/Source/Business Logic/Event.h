//
//  Event.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "_Event.h"
#import "EventKit.h"
#import <JMImageCache/JMImageCache.h>


@protocol EventDelegate;

@interface Event : _Event <Event, JMImageCacheDelegate>

@property (nonatomic, weak) id<EventDelegate> delegate;

@property (nonatomic, strong) JMImageCache *imageCache;

@end
