//
//  EventResult.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EventStore;
@protocol Event;
@protocol EventResultsControllerDelegate;

typedef NSString * (^EventSectionNameBlock)(id<Event> event);


@interface EventResultsController : NSObject

@property (nonatomic, weak) id<EventResultsControllerDelegate> delegate;
@property (nonatomic, readonly) EventSectionNameBlock sectionNameBlock;
@property (nonatomic, strong) NSPredicate *predicate;


- (instancetype)initWithEventStore:(id<EventStore>)eventStore sectionNameBlock:(EventSectionNameBlock)sectionNameBlock;
- (void)performFetch:(NSError **)error;

// Accessing results
- (id<Event>)eventForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForEvent:(id<Event>)event;

// Querying section information
@property (nonatomic, readonly) NSArray *sections;

@end
