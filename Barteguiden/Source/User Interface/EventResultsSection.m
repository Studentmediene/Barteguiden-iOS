//
//  EventResultsSection.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 22.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventResultsSection.h"


@interface EventResultsSection ()

@property (nonatomic, strong) NSMutableArray *events;

@end


@implementation EventResultsSection

- (instancetype)initWithEvents:(NSArray *)events
{
    self = [super init];
    if (self) {
        _events = [NSMutableArray arrayWithArray:events];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    EventResultsSection *section = [[EventResultsSection alloc] initWithEvents:_events];
    section.name = [_name copy];
    
    return section;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: 0x%x; name = %@, eventCount = %d>", self.class, (NSUInteger)self, _name, [_events count]];
}


#pragma mark - Adding Objects

- (NSUInteger)addObject:(id)object usingSortDescriptors:(NSArray *)sortDescriptors
{
    [_events addObject:object];
    [_events sortUsingDescriptors:sortDescriptors];
    return [_events indexOfObject:object];
}


#pragma mark - Accessing Objects

- (NSUInteger)numberOfEvents
{
    return [_events count];
}

- (NSArray *)events
{
    return [_events copy];
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
