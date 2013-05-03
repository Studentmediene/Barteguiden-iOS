//
//  EventStoreCommunicator.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EventStoreCommunicatorDelegate;

@interface EventStoreCommunicator : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<EventStoreCommunicatorDelegate> delegate;

// Downloading
- (void)downloadEventChanges;
- (void)startDownloadWithURLRequest:(NSURLRequest *)urlRequest;

// Notify delegate
- (void)notifyDidFinishLoadingWithData:(NSData *)data;
- (void)notifyDidFailWithError:(NSError *)error;

// API resources
- (NSURL *)URLForEvents;
- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size;;

@end
