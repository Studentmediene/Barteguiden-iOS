//
//  NSArray+RIOClassifier.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "NSArray+RIOClassifier.h"


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


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

- (NSDictionary *)classifyObjectsUsingSelector:(SEL)selector
{
    return [self classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        id<NSCopying> key = nil;
        SuppressPerformSelectorLeakWarning(key = [obj performSelector:selector]);
        return key;
    }];
}

@end
