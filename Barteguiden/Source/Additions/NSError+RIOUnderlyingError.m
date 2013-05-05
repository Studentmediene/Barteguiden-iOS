//
//  NSError+RIOUnderlyingError.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "NSError+RIOUnderlyingError.h"

@implementation NSError (RIOUnderlyingError)

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)underlyingError
{
    return [[[self class] alloc] initWithDomain:domain code:code underlyingError:underlyingError];
}

- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)underlyingError
{
    NSDictionary *userInfo = nil;
    if (underlyingError) {
        userInfo = @{NSUnderlyingErrorKey: underlyingError};
    }
    
    NSError *reportableError = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return reportableError;
}

- (NSError *)underlyingError
{
    return self.userInfo[NSUnderlyingErrorKey];
}

@end
