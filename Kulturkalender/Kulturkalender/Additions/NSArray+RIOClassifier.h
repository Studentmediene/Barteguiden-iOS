//
//  NSArray+RIOClassifier.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RIOClassifier)

- (NSDictionary *)classifyObjectsUsingBlock:(id<NSCopying> (^)(id obj))block;
- (NSDictionary *)classifyObjectsUsingKeyPath:(NSString *)keyPath;

@end
