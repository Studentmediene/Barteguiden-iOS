//
//  EventResultsControllerDelegate.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, EventResultsChangeType) {
    EventResultsChangeInsert = 1,
    EventResultsChangeDelete = 2,
    EventResultsChangeMove = 3,
    EventResultsChangeUpdate = 4
};


@class EventResultsController;
@protocol EventResultsSectionInfo;

@protocol EventResultsControllerDelegate <NSObject>

@optional

// Responding to Changes
- (void)eventResultsControllerWillChangeContent:(EventResultsController *)controller;
- (void)eventResultsController:(EventResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(EventResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)eventResultsController:(EventResultsController *)controller didChangeSection:(id<EventResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(EventResultsChangeType)type;
- (void)eventResultsControllerDidChangeContent:(EventResultsController *)controller;

// Customizing Section Names
//- (NSString *)eventResultsController:(EventResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;

@end
