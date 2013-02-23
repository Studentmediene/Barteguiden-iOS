//
//  EventResult.m
//  Kulturkalender
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
    _fetchedEvents = [NSMutableArray arrayWithArray:events];
    
    [self sortFetchedEvents];
    [self generateSections];
}

- (void)sortFetchedEvents
{
    [_fetchedEvents sortUsingDescriptors:self.sortDescriptors];
}

- (void)generateSections
{
    [_sections removeAllObjects];
    
    NSMutableArray *sections = [NSMutableArray array];
    
    __block NSString *lastSectionName = nil;
    NSDictionary *sectionObjects = [self.fetchedEvents classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
        NSString *sectionName = self.sectionNameBlock(obj);
        
        if ([sectionName isEqual:lastSectionName] == NO) {
            [sections addObject:sectionName];
        }
        
        lastSectionName = sectionName;
        
        return sectionName;
    }];
    
    for (NSString *sectionName in sections) {
        [self addSectionWithName:sectionName objects:sectionObjects[sectionName]];
    }
}


#pragma mark - Notifications

- (void)eventStoreChanged:(NSNotification *)note
{
    // Get changed events
    NSSet *inserted = [self filteredEventsFromUserInfo:note.userInfo forKey:EventStoreInsertedEventsKey];
    NSSet *updated = [self filteredEventsFromUserInfo:note.userInfo forKey:EventStoreUpdatedEventsKey];
    NSSet *deleted = [self filteredEventsFromUserInfo:note.userInfo forKey:EventStoreDeletedEventsKey];
    
    [self updateFetchedObjectsForInserted:inserted updated:updated deleted:deleted];
}

- (NSSet *)filteredEventsFromUserInfo:(NSDictionary *)userInfo forKey:(NSString *)key
{
    NSSet *events = userInfo[key];
    return [events filteredSetUsingPredicate:self.predicate];
}


#pragma mark - Accessing Results

- (NSArray *)fetchedEvents
{
    return [_fetchedEvents copy];
}

- (id<Event>)eventForIndexPath:(NSIndexPath *)indexPath
{
    id<EventResultsSectionInfo> section = _sections[indexPath.section];
    return section.events[indexPath.row];
}

- (NSIndexPath *)indexPathForEvent:(id<Event>)event
{
    NSString *sectionName = self.sectionNameBlock(event);
    
    NSUInteger sectionIndex = [self indexOfSectionWithName:sectionName];
    if (sectionIndex == NSNotFound) {
        return nil;
    }
    
    EventResultsSection *section = _sections[sectionIndex];
    NSUInteger itemIndex = [section.events indexOfObject:event];
    if (itemIndex == NSNotFound) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex];
}


#pragma mark - Querying Section Information

- (NSArray *)sections
{
    return [_sections copy];
}


#pragma mark - Update fetched objects

- (void)updateFetchedObjectsForInserted:(NSSet *)inserted updated:(NSSet *)updated deleted:(NSSet *)deleted
{
    // Pre-update
    NSSet *newSections = [self namesOfNewSectionsForInsertedEvents:inserted];
    
    NSDictionary *indicesForDeletedSections = [self indicesOfSectionsWithEvents:deleted];
    NSDictionary *indexPathsForUpdatedEvents = [self indexPathsForEvents:updated];
    NSDictionary *indexPathsForDeletedEvents = [self indexPathsForEvents:deleted];
    
    // Update fetched events
    [self addInsertedEventsToFetchedEvents:inserted];
    [self removeDeletedEventsFromFetchedEvents:deleted];
    
    [self sortFetchedEvents];
    [self generateSections];
    
    // Post-update
    NSSet *deletedSections = [self namesOfDeletedSectionsForDeletedEvents:deleted];
    
    [self notifyWillChangeContent];
    
    if ([self delegateRespondsToChangedSection] == YES) {
        [self notifyNewSections:newSections];
        [self notifyDeletedSections:deletedSections withIndices:indicesForDeletedSections];
    }
    
    if ([self delegateRespondsToChangedObject] == YES) {
        [self notifyNewItemsForInsertedEvents:inserted];
        [self notifyUpdatedItemsForUpdatedEvents:updated withIndexPaths:indexPathsForUpdatedEvents];
        [self notifyDeletedItemsForDeletedEvents:deleted withIndexPaths:indexPathsForDeletedEvents];
    }
    
    [self notifyDidChangeContent];
}

- (NSDictionary *)indexPathsForEvents:(NSSet *)events
{
    NSMutableDictionary *indexPaths = [NSMutableDictionary dictionary];
    
    for (id<Event> event in events) {
        NSIndexPath *indexPath = [self indexPathForEvent:event];
        if (indexPath != nil) {
            [indexPaths setObject:indexPath forKey:[event eventIdentifier]];
        }
    }
    
    return [indexPaths copy];
}

- (NSDictionary *)indicesOfSectionsWithEvents:(NSSet *)events
{
    NSMutableDictionary *indices = [NSMutableDictionary dictionary];
    
    for (id<Event> event in events) {
        NSString *sectionName = self.sectionNameBlock(event);
        NSUInteger index = [self indexOfSectionWithName:sectionName];
        if (index != NSNotFound) {
            [indices setObject:@(index) forKey:sectionName];
        }
    }
    
    return [indices copy];
}


#pragma mark - Update fetched events

- (void)addInsertedEventsToFetchedEvents:(NSSet *)events
{
    [_fetchedEvents addObjectsFromArray:[events allObjects]];
}

- (void)removeDeletedEventsFromFetchedEvents:(NSSet *)events
{
    [_fetchedEvents removeObjectsInArray:[events allObjects]];
}

- (NSSet *)namesOfNewSectionsForInsertedEvents:(NSSet *)events
{
    NSMutableSet *newSections = [NSMutableSet set];
    
    for (id<Event> event in events) {
        NSString *sectionName = self.sectionNameBlock(event);
        if ([self indexOfSectionWithName:sectionName] == NSNotFound) {
            [newSections addObject:sectionName];
        }
    }
    
    return [newSections copy];
}

- (NSSet *)namesOfDeletedSectionsForDeletedEvents:(NSSet *)events
{
    NSMutableSet *deletedSections = [NSMutableSet set];
    
    for (id<Event> event in events) {
        NSString *sectionName = self.sectionNameBlock(event);
        if ([self indexOfSectionWithName:sectionName] == NSNotFound) {
            [deletedSections addObject:sectionName];
        }
    }
    
    return [deletedSections copy];
}


#pragma mark - Notify delegate

- (void)notifyWillChangeContent
{
    if ([self.delegate respondsToSelector:@selector(eventResultsControllerWillChangeContent:)]) {
        [self.delegate eventResultsControllerWillChangeContent:self];
    }
}

- (void)notifyDidChangeContent
{
    if ([self.delegate respondsToSelector:@selector(eventResultsControllerDidChangeContent:)]) {
        [self.delegate eventResultsControllerDidChangeContent:self];
    }
}

- (BOOL)delegateRespondsToChangedSection
{
    return [self.delegate respondsToSelector:@selector(eventResultsController:didChangeSection:atIndex:forChangeType:)];
}

- (BOOL)delegateRespondsToChangedObject
{
    return [self.delegate respondsToSelector:@selector(eventResultsController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)];
}

- (void)notifyNewSections:(NSSet *)newSections
{
    for (NSString *sectionName in newSections) {
        NSUInteger index = [self indexOfSectionWithName:sectionName];
        EventResultsSection *section = _sections[index];
        [self.delegate eventResultsController:self didChangeSection:section atIndex:index forChangeType:EventResultsChangeInsert];
    }
}

- (void)notifyDeletedSections:(NSSet *)deletedSections withIndices:(NSDictionary *)indices
{
    for (NSString *sectionName in deletedSections) {
        NSUInteger index = [[indices objectForKey:sectionName] unsignedIntegerValue];
        EventResultsSection *section = _sections[index];
        [self.delegate eventResultsController:self didChangeSection:section atIndex:index forChangeType:EventResultsChangeInsert];
    }
}

- (void)notifyNewItemsForInsertedEvents:(NSSet *)events
{
    for (id<Event> event in events) {
        NSIndexPath *newIndexPath = [self indexPathForEvent:event];
        [self.delegate eventResultsController:self didChangeObject:event atIndexPath:nil forChangeType:EventResultsChangeInsert newIndexPath:newIndexPath];
    }
}

- (void)notifyUpdatedItemsForUpdatedEvents:(NSSet *)events withIndexPaths:(NSDictionary *)indexPaths
{
    for (id<Event> event in events) {
        NSIndexPath *indexPath = [indexPaths objectForKey:[event eventIdentifier]];
        NSIndexPath *newIndexPath = [self indexPathForEvent:event];
        
        if ([indexPath isEqual:newIndexPath]) {
            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:indexPath forChangeType:EventResultsChangeUpdate newIndexPath:newIndexPath];
        }
        else {
            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:indexPath forChangeType:EventResultsChangeMove newIndexPath:newIndexPath];
        }
    }
}

- (void)notifyDeletedItemsForDeletedEvents:(NSSet *)events withIndexPaths:(NSDictionary *)indexPaths
{
    for (id<Event> event in events) {
        NSIndexPath *indexPath = [indexPaths objectForKey:[event eventIdentifier]];
            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:indexPath forChangeType:EventResultsChangeDelete newIndexPath:nil];
    }
}


#pragma mark - Private methods

- (void)addSectionWithName:(NSString *)sectionName objects:(NSArray *)objects
{
    EventResultsSection *section = [[EventResultsSection alloc] initWithObjects:objects];
    section.name = sectionName;
    [_sections addObject:section];
}

- (NSUInteger)indexOfSectionWithName:(NSString *)sectionName
{
    for (NSUInteger i = 0, l = [_sections count]; i < l; i++) {
        EventResultsSection *section = _sections[i];
        if ([section.name isEqualToString:sectionName]) {
            return i;
        }
    }
    
    return NSNotFound;
}

@end
