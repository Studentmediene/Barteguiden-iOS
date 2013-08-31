//
//  EventResult.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventResultsController.h"
#import "EventResultsControllerDelegate.h"
#import "EventResultsSection.h"

#import "EventKit.h"
#import "NSArray+RIOClassifier.h"


@interface EventResultsController ()

@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) id<EventStore> eventStore;
@property (nonatomic, strong) EventSectionNameBlock sectionNameBlock;

@end


@implementation EventResultsController

- (instancetype)initWithEventStore:(id<EventStore>)eventStore sectionNameBlock:(EventSectionNameBlock)sectionNameBlock
{
    self = [super init];
    if (self) {
        _eventStore = eventStore;
        _sectionNameBlock = sectionNameBlock;
        _sections = [NSArray array];
    }
    return self;
}

- (void)performFetchWithPredicate:(NSPredicate *)predicate cacheName:(NSString *)cacheName error:(NSError **)error
{
    NSArray *cachedSections = [[[self class] cachedSections] objectForKey:cacheName];
    if (cachedSections != nil) {
        NSLog(@"Found events in cache:%@", cacheName);
        _sections = cachedSections;
        return;
    }
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate error:error];
    NSLog(@"Fetched events:%d", [events count]);
    
    _sections = [self generateSectionsForEvents:events];
    
    [[[self class] cachedSections] setObject:_sections forKey:cacheName];
}


#pragma mark - Accessing Results

- (id<Event>)eventForIndexPath:(NSIndexPath *)indexPath
{
    id<EventResultsSectionInfo> section = _sections[indexPath.section];
    return section.events[indexPath.row];
}

- (NSIndexPath *)indexPathForEvent:(id<Event>)event
{
    return [self indexPathForEvent:event inSections:_sections];
}


#pragma mark - Querying Section Information

- (NSArray *)sections
{
    return [_sections copy];
}


#pragma mark - Private methods

- (NSArray *)generateSectionsForEvents:(NSArray *)events
{
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *sectionNames = [NSMutableArray array];
    
    __block NSString *lastSectionName = nil;
    NSDictionary *sectionEvents = [events classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        NSString *sectionName = self.sectionNameBlock(obj);
        
        if ([sectionName isEqual:lastSectionName] == NO) {
            [sectionNames addObject:sectionName];
        }
        
        lastSectionName = sectionName;
        
        return sectionName;
    }];
    
    for (NSString *sectionName in sectionNames) {
        EventResultsSection *section = [[EventResultsSection alloc] initWithEvents:sectionEvents[sectionName]];
        section.name = sectionName;
        
        [sections addObject:section];
    }
    
    return [sections copy];
}

- (NSIndexPath *)indexPathForEvent:(id<Event>)event inSections:(NSArray *)sections
{
    NSString *sectionName = self.sectionNameBlock(event);
    
    NSUInteger sectionIndex = [self indexOfSectionWithName:sectionName inSections:sections];
    if (sectionIndex == NSNotFound) {
        return nil;
    }
    
    EventResultsSection *section = sections[sectionIndex];
    NSUInteger itemIndex = [self indexOfEvent:event inSection:section];
    if (itemIndex == NSNotFound) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex];
}

- (NSUInteger)indexOfSectionWithName:(NSString *)sectionName inSections:(NSArray *)sections
{
    for (NSUInteger i = 0, l = [sections count]; i < l; i++) {
        EventResultsSection *section = sections[i];
        if ([section.name isEqualToString:sectionName]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSUInteger)indexOfEvent:(id<Event>)event inSection:(EventResultsSection *)section
{
    NSArray *events = [section events];
    return [events indexOfObject:event];
}


#pragma mark - Cache

+ (void)clearCache
{
    NSLog(@"Clearing cache in %@", NSStringFromClass([self class]));
    [[self cachedSections] removeAllObjects];
}

+ (void)deleteCacheWithName:(NSString *)cacheName
{
    NSLog(@"Deleting cache (%@) in %@", cacheName, NSStringFromClass([self class]));
    [[self cachedSections] removeObjectForKey:cacheName];
}

+ (NSCache *)cachedSections
{
    static NSCache *_cachedSections;
    if (_cachedSections == nil) {
        _cachedSections = [[NSCache alloc] init];
    }
    
    return _cachedSections;
}

@end
