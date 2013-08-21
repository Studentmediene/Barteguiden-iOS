//
//  EventDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 15.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Event;

@protocol EventDelegate <NSObject>

- (void)eventDidChange:(Event *)event;
- (void)eventStartedDownloadingData:(Event *)event;
- (void)eventFinishedDownloadingData:(Event *)event;
- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size;

@end
