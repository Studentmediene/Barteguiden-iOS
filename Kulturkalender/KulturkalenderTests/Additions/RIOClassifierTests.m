//
//  RIOClassifierTests.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//


// Class under test
#import "NSArray+RIOClassifier.h"

// Collaborators


// Test support
#import <SenTestingKit/SenTestingKit.h>


@interface RIOClassifierTests : SenTestCase
@end


@implementation RIOClassifierTests

- (void)setUp
{
}

- (void)tearDown
{
}


#pragma mark - Tests

- (void)testClassifyEmptyArrayUsingBlockShouldReturnEmptyDictionary
{
    NSArray *emptyArray = @[];
    NSDictionary *result = [emptyArray classifyObjectsUsingBlock:nil];
    STAssertEqualObjects(result, @{}, @"Not an empty dictionary");
}

- (void)testClassifyObjectsUsingBlockThatReturnsStaticTextShouldReturnDictionaryWithOneGroupContainingAllObjects
{
    NSArray *objects = @[@1, @2, @3];
    NSDictionary *result = [objects classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        return @"key";
    }];
    STAssertEqualObjects(result, @{@"key": objects}, @"Mismatching dictionary");
}

- (void)testClassifyObjectsUsingBlockThatReturnsNilShouldReturnEmptyDictionary
{
    NSArray *objects = @[@1, @2, @3];
    NSDictionary *result = [objects classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        return nil;
    }];
    STAssertEqualObjects(result, @{}, @"Not an empty dictionary");
}

- (void)testClassifyObjectsUsingBlockThatReturnsStaticTextButSkipsNullObjectShouldReturnDictionaryWithOneGroupContainingAllObjectsExceptNullObject
{
    NSArray *objects = @[@1, @2, [NSNull null], @3];
    NSDictionary *result = [objects classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        if ([obj isEqual:[NSNull null]]) {
            return nil;
        }
        
        return @"key";
    }];
    STAssertEqualObjects(result, (@{@"key": @[@1, @2, @3]}), @"Mismatching dictionary");
}

- (void)testClassifyObjectsUsingBlockThatReturnsSelfShouldReturnDictionaryWithThreeGroupsContainingThemselves
{
    NSArray *objects = @[@1, @2, @3];
    NSDictionary *result = [objects classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        return obj;
    }];
    STAssertEqualObjects(result, (@{@1: @[@1], @2: @[@2], @3: @[@3]}), @"Mismatching dictionary");
}

- (void)testClassifyObjectsUsingBlockThatReturnsFirstDigitAsKeyShouldReturnDictionaryWithTwoGroups
{
    NSArray *objects = @[@1001, @1002, @2001];
    NSDictionary *result = [objects classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        NSNumber *firstDigit = @([obj integerValue] / 1000);
        return firstDigit;
    }];
    STAssertEqualObjects(result, (@{@1: @[@1001, @1002], @2: @[@2001]}), @"Mismatching dictionary");
}

- (void)testClassifyObjectsUsingStringValueAsKeyPathShouldReturnDictionaryWithThreeGroupsContainingThemselves
{
    NSArray *objects = @[@1, @2, @3];
    NSDictionary *result = [objects classifyObjectsUsingKeyPath:@"stringValue"];
    STAssertEqualObjects(result, (@{@"1": @[@1], @"2": @[@2], @"3": @[@3]}), @"Mismatching dictionary");
}

@end
