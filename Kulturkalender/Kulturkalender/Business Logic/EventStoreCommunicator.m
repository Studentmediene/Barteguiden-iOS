//
//  EventStoreCommunicator.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventStoreCommunicator.h"
#import "EventStoreCommunicatorDelegate.h"


static NSString * const kInsertedKey = @"inserted";
static NSString * const kUpdatedKey = @"updated";
static NSString * const kDeletedKey = @"deleted";


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
    NSURL *url = [self URLForEventChangesSince:[NSDate date]]; // TODO: Fix date
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
        NSArray *inserted = jsonObject[kInsertedKey];
        NSArray *updated = jsonObject[kUpdatedKey];
        NSArray *deleted = jsonObject[kDeletedKey];
        
        [self.delegate communicator:self didReceiveEventChangesWithInserted:inserted updated:updated deleted:deleted];
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

- (NSURL *)URLForEventChangesSince:(NSDate *)since
{
    NSParameterAssert(since != nil);
    return [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"]; // TODO: Remove
//    return [NSURL URLWithString:@"https://dl.dropbox.com/u/10851469/Under%20Dusken/Kulturkalender/Data.json"]; // TODO: Remove
//    NSTimeInterval timeInterval = [since timeIntervalSince1970];
//    NSString *changesPath = [NSString stringWithFormat:@"api/events/changes?since=%.0f", timeInterval];
//    return [NSURL URLWithString:changesPath relativeToURL:[self baseURL]];
}

- (NSURL *)URLForImageWithEventID:(NSString *)eventID size:(CGSize)size
{
    NSParameterAssert(eventID != nil);
//    NSString *imagePath = [NSString stringWithFormat:@"events/%@.png?size=%dx%d", eventID, (int)size.width, (int)size.height];
    NSString *imagePath = [NSString stringWithFormat:@"img/%@.png", eventID];
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
