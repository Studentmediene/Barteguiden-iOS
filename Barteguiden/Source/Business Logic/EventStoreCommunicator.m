//
//  EventStoreCommunicator.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreCommunicator.h"
#import "EventStoreCommunicatorDelegate.h"


static NSString * const kEventsKey = @"events";


@interface EventStoreCommunicator ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;

@end


@implementation EventStoreCommunicator

- (id)init
{
    self = [super init];
    if (self) {
        _receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)downloadEventChanges
{
    NSURL *url = [self URLForEvents];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    [self startDownloadWithURLRequest:urlRequest];
}

- (void)startDownloadWithURLRequest:(NSURLRequest *)urlRequest
{
    [self resetConnection];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self notifyDidFailWithError:error];
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self notifyDidFinishLoadingWithData:self.receivedData];
}


#pragma mark - Notify delegate

- (void)notifyDidFinishLoadingWithData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (jsonObject != nil) {
        NSArray *events = jsonObject[kEventsKey];
        
        [self.delegate communicator:self didReceiveEvents:events];
    }
    else {
        [self.delegate communicator:self didFailWithError:error];
    }
}

- (void)notifyDidFailWithError:(NSError *)error
{
    [self.delegate communicator:self didFailWithError:error];
}


#pragma mark - API resources

- (NSURL *)URLForEvents
{
//    return [[NSBundle mainBundle] URLForResource:@"Samfundet" withExtension:@"json"]; // TODO: Remove
//    return [NSURL URLWithString:@"http://barteguiden.no/v1/events"];
#warning Change back to correct API
    return [NSURL URLWithString:@"http://skohorn-mbp10-1.local:3000/events"];
}

- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size
{
    NSParameterAssert(eventID != nil);
    NSString *imagePath = [NSString stringWithFormat:@"http://underdusken.no/barteguiden/v1/events/%@.jpg", eventID];
    if (CGSizeEqualToSize(size, CGSizeZero) == NO) {
        imagePath = [imagePath stringByAppendingFormat:@"?size=%.0fx%.0f", size.width, size.height];
    }
    
    return [NSURL URLWithString:imagePath relativeToURL:[self baseURL]];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:@"http://kk.skohorn.net/"]; // TODO: Fix
}


#pragma mark - Private methods

- (void)resetConnection
{
    [self.connection cancel];
    [self.receivedData setLength:0];
}

@end
