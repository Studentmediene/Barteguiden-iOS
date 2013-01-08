//
//  NSError+RIOUnderlyingError.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 08.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (RIOUnderlyingError)

- (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)underlyingError;

- (NSError *)underlyingError;

@end
