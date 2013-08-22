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

@property (nonatomic, strong) id<EventStore> eventStore;

@end


@implementation EventResultsController {
    NSMutableArray *_fetchedEvents;
    NSMutableArray *_sections;
}


- (instancetype)initWithEventStore:(id<EventStore>)eventStore sectionNameBlock:(EventSectionNameBlock)sectionNameBlock
{
    self = [super init];
    if (self) {
        _eventStore = eventStore;
        _sectionNameBlock = sectionNameBlock;
        
        _sections = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EventStoreChangedNotification object:self.eventStore];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EventStoreChangedNotification object:self.eventStore];
}

- (void)performFetch:(NSError **)error
{
    NSArray *events = [self.eventStore eventsMatchingPredicate:self.predicate error:error];
    NSLog(@"Fetched events:%d", [events count]);
    
    [self generateSectionsForEvents:events];
}

- (void)generateSectionsForEvents:(NSArray *)events
{
    [_sections removeAllObjects];
    
    NSMutableArray *sections = [NSMutableArray array];
    
    __block NSString *lastSectionName = nil;
    NSDictionary *sectionEvents = [events classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        NSString *sectionName = self.sectionNameBlock(obj);
        
        if ([sectionName isEqual:lastSectionName] == NO) {
            [sections addObject:sectionName];
        }
        
        lastSectionName = sectionName;
        
        return sectionName;
    }];
    
    for (NSString *sectionName in sections) {
        [self addSectionWithName:sectionName events:sectionEvents[sectionName]];
    }
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


#pragma mark - Notifications

- (void)eventStoreChanged:(NSNotification *)note
{
    // FIXME: Reset cache
}


#pragma mark - Private methods

- (void)addSectionWithName:(NSString *)sectionName events:(NSArray *)events
{
    EventResultsSection *section = [[EventResultsSection alloc] initWithEvents:events];
    section.name = sectionName;
    [_sections addObject:section];
}

- (NSUInteger)indexOfSectionWithName:(NSString *)sectionName
{
    return [self indexOfSectionWithName:sectionName inSections:_sections];
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

@end
