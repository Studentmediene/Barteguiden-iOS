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
// TODO: Remove
- (void)setPredicate:(NSPredicate *)predicate withAnimation:(BOOL)animation
{
    NSLog(@"Transitioning to new predicate");
    self.predicate = predicate;
    
    NSArray *oldFetchedEvents = [_fetchedEvents copy];
    NSArray *newFetchedEvents = [self.eventStore eventsMatchingPredicate:predicate error:NULL];
    
    // Find deleted events
    NSMutableSet *inserted = [NSMutableSet set];
    for (id<Event> event in newFetchedEvents) {
        if ([oldFetchedEvents containsObject:event] == NO) {
            [inserted addObject:event];
        }
    }
    
    // Find inserted events
    NSMutableSet *deleted = [NSMutableSet set];
    for (id<Event> event in oldFetchedEvents) {
        if ([newFetchedEvents containsObject:event] == NO) {
            [deleted addObject:event];
        }
    }
    
    [self updateFetchedEventsForInserted:inserted updated:nil deleted:deleted];
}

- (void)performFetch:(NSError **)error
{
    NSArray *events = [self.eventStore eventsMatchingPredicate:self.predicate error:error];
    _fetchedEvents = [NSMutableArray arrayWithArray:events];
    NSLog(@"Fetched events:%d", [events count]);
    
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
    NSDictionary *sectionEvents = [self.fetchedEvents classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
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


#pragma mark - Notifications

- (void)eventStoreChanged:(NSNotification *)note
{
    // Get changed events
    NSSet *inserted = note.userInfo[EventStoreInsertedEventsUserInfoKey];
    NSSet *updated = note.userInfo[EventStoreUpdatedEventsUserInfoKey];
    NSSet *deleted = note.userInfo[EventStoreDeletedEventsUserInfoKey];
    
    NSLog(@"Inserted events:%d updated:%d deleted:%d", [inserted count], [updated count], [deleted count]);
    
    [self updateFetchedEventsForInserted:inserted updated:updated deleted:deleted];
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
    return [self indexPathForEvent:event inSections:_sections];
}


#pragma mark - Querying Section Information

- (NSArray *)sections
{
    return [_sections copy];
}


#pragma mark - Update fetched events

- (void)updateFetchedEventsForInserted:(NSSet *)inserted updated:(NSSet *)updated deleted:(NSSet *)deleted
{
    NSArray *oldSections = [self deepCopySections:_sections];
    
    // Pre-update
    inserted = [inserted filteredSetUsingPredicate:self.predicate];
    [self moveUpdated:&updated toInserted:&inserted orDeleted:&deleted];
    updated = [updated filteredSetUsingPredicate:self.predicate];
    
    NSSet *newSections = [self sectionNamesThatDoesNotExistForEvents:inserted];
    
    // Update fetched events
    [self addInsertedEventsToFetchedEvents:inserted];
    [self removeDeletedEventsFromFetchedEvents:deleted];
    
    [self sortFetchedEvents];
    [self generateSections];
    
    // Post-update
    NSSet *deletedSections = [self sectionNamesThatDoesNotExistForEvents:deleted];
    
    // Notify delegate
    [self notifyWillChangeContent];
    
    if ([self delegateRespondsToChangedSection] == YES) {
        [self notifyNewSections:newSections];
        [self notifyDeletedSections:deletedSections withOldSections:oldSections];
    }
    
    if ([self delegateRespondsToChangedObject] == YES) {
        [self notifyNewItemsForInsertedEvents:inserted];
        [self notifyUpdatedItemsForUpdatedEvents:updated withOldSections:oldSections];
        [self notifyDeletedItemsForDeletedEvents:deleted withOldSections:oldSections];
    }
    
    [self notifyDidChangeContent];
}

- (void)moveUpdated:(NSSet **)updated toInserted:(NSSet **)inserted orDeleted:(NSSet **)deleted
{
    // Create mutable sets from immutable sets
    NSMutableSet *mutableUpdated = [NSMutableSet setWithSet:*updated];
    NSMutableSet *mutableInserted = [NSMutableSet setWithSet:*inserted];
    NSMutableSet *mutableDeleted = [NSMutableSet setWithSet:*deleted];
    
    // Check if updated events should be moved
    for (id<Event> event in *updated) {
        // Should delete event?
        if ([_fetchedEvents containsObject:event] == YES) {
            if ([self.predicate evaluateWithObject:event] == NO) {
                [mutableUpdated removeObject:event];
                [mutableDeleted addObject:event];
            }
        }
        // Should insert event?
        else {
            if ([self.predicate evaluateWithObject:event] == YES) {
                [mutableUpdated removeObject:event];
                [mutableInserted addObject:event];
            }
        }
    }
    
    // Update
    *inserted = [mutableInserted copy];
    *updated = [mutableUpdated copy];
    *deleted = [mutableDeleted copy];
}

- (void)addInsertedEventsToFetchedEvents:(NSSet *)events
{
    [_fetchedEvents addObjectsFromArray:[events allObjects]];
}

- (void)removeDeletedEventsFromFetchedEvents:(NSSet *)events
{
    [_fetchedEvents removeObjectsInArray:[events allObjects]];
}

- (NSSet *)sectionNamesThatDoesNotExistForEvents:(NSSet *)events
{
    NSMutableSet *sectionNames = [NSMutableSet set];
    
    for (id<Event> event in events) {
        NSString *sectionName = self.sectionNameBlock(event);
        if ([self indexOfSectionWithName:sectionName] == NSNotFound) {
            [sectionNames addObject:sectionName];
        }
    }
    
    return [sectionNames copy];
}


#pragma mark - Notify delegate

- (BOOL)delegateRespondsToChangedSection
{
    return [self.delegate respondsToSelector:@selector(eventResultsController:didChangeSection:atIndex:forChangeType:)];
}

- (BOOL)delegateRespondsToChangedObject
{
    return [self.delegate respondsToSelector:@selector(eventResultsController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)];
}

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

- (void)notifyNewSections:(NSSet *)newSections
{
    for (NSString *sectionName in newSections) {
        NSUInteger newIndex = [self indexOfSectionWithName:sectionName];
        EventResultsSection *section = _sections[newIndex];
        [self.delegate eventResultsController:self didChangeSection:section atIndex:newIndex forChangeType:EventResultsChangeInsert];
    }
}

- (void)notifyDeletedSections:(NSSet *)deletedSections withOldSections:(NSArray *)oldSections
{
    for (NSString *sectionName in deletedSections) {
        NSUInteger oldIndex = [self indexOfSectionWithName:sectionName inSections:oldSections];
        if (oldIndex != NSNotFound) {
            EventResultsSection *section = oldSections[oldIndex];
            [self.delegate eventResultsController:self didChangeSection:section atIndex:oldIndex forChangeType:EventResultsChangeDelete];
        }
    }
}

- (void)notifyNewItemsForInsertedEvents:(NSSet *)events
{
    for (id<Event> event in events) {
        NSIndexPath *newIndexPath = [self indexPathForEvent:event];
        [self.delegate eventResultsController:self didChangeObject:event atIndexPath:nil forChangeType:EventResultsChangeInsert newIndexPath:newIndexPath];
    }
}

- (void)notifyUpdatedItemsForUpdatedEvents:(NSSet *)events withOldSections:(NSArray *)oldSections
{
    for (id<Event> event in events) {
        NSIndexPath *oldIndexPath = [self indexPathForEvent:event inSections:oldSections];
        NSIndexPath *newIndexPath = [self indexPathForEvent:event];
        
//        if ([indexPath isEqual:newIndexPath]) {
            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:oldIndexPath forChangeType:EventResultsChangeUpdate newIndexPath:newIndexPath];
//        }
//        else {
//            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:oldIndexPath forChangeType:EventResultsChangeMove newIndexPath:newIndexPath];
//        }
    }
}

- (void)notifyDeletedItemsForDeletedEvents:(NSSet *)events withOldSections:(NSArray *)oldSections
{
    for (id<Event> event in events) {
        NSIndexPath *oldIndexPath = [self indexPathForEvent:event inSections:oldSections];
        if (oldIndexPath != nil) {
            [self.delegate eventResultsController:self didChangeObject:event atIndexPath:oldIndexPath forChangeType:EventResultsChangeDelete newIndexPath:nil];
        }
    }
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

- (NSArray *)deepCopySections:(NSArray *)sections
{
    NSMutableArray *copiedSections = [NSMutableArray array];
    
    for (EventResultsSection *section in sections) {
        [copiedSections addObject:[section copy]];
    }
    
    return [copiedSections copy];
}

@end
