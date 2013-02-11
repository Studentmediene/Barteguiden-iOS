//
//  EventResult.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EventStore;
@protocol EventResultsController;
@protocol Event;

@interface EventResultsController : NSObject

@property (nonatomic, weak) id<EventResultsController> delegate;
@property (nonatomic, strong) NSString *sectionNameKeyPath;
@property (nonatomic, strong) NSPredicate *predicate;

- (instancetype)initWithEventStore:(id<EventStore>)eventStore sectionNameKeyPath:(NSString *)section;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;
- (NSString *)titleForSection:(NSUInteger)section;
- (id<Event>)eventForIndexPath:(NSIndexPath *)indexPath;

@end
