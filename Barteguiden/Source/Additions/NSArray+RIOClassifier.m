//
//  NSArray+RIOClassifier.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "NSArray+RIOClassifier.h"


@implementation NSArray (RIOClassifier)

- (NSDictionary *)classifyObjectsUsingBlock:(id<NSCopying> (^)(id obj))block
{
    if ([self count] == 0) {
        return @{};
    }
    
    NSMutableDictionary *classifiedObjects = [NSMutableDictionary dictionary];
    
    for (id obj in self) {
        id<NSCopying> key = block(obj);
        if (key == nil) {
            continue;
        }
        
        NSArray *currentObjects = classifiedObjects[key] ?: [NSArray array];
        currentObjects = [currentObjects arrayByAddingObject:obj];
        classifiedObjects[key] = currentObjects;
    }
    
    return [classifiedObjects copy];
}

- (NSDictionary *)classifyObjectsUsingKeyPath:(NSString *)keyPath
{
    return [self classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        return [obj valueForKeyPath:keyPath];
    }];
}

@end
