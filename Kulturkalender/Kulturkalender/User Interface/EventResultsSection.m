//
//  EventResultsSection.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 22.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventResultsSection.h"


@interface EventResultsSection ()

@property (nonatomic, strong) NSMutableArray *objects;

@end


@implementation EventResultsSection

- (id)initWithObjects:(NSArray *)objects
{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray arrayWithArray:objects];
    }
    return self;
}

#pragma mark - Adding Objects

- (NSUInteger)addObject:(id)object usingSortDescriptors:(NSArray *)sortDescriptors;
{
    [self.objects addObject:object];
    [self.objects sortUsingDescriptors:sortDescriptors];
    return [self.objects indexOfObject:object];
}


#pragma mark - Accessing Objects

- (NSUInteger)numberOfEvents
{
    return [self.objects count];
}

- (NSArray *)events
{
    return [self.objects copy];
}


#pragma mark - Accessing the Name and Title

//- (NSString *)name
//{
//    return @"TEMP NAME";
//}

// TODO: Implement
//- (NSString *)indexTitle
//{
//    return nil;
//}


@end
