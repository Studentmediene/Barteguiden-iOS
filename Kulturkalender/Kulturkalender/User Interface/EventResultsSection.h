//
//  EventResultsSection.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 22.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventResultsSectionInfo.h"

@interface EventResultsSection : NSObject <NSCopying, EventResultsSectionInfo>

@property (nonatomic, strong) NSString *name;

- (instancetype)initWithEvents:(NSArray *)objects;

- (NSUInteger)addObject:(id)object usingSortDescriptors:(NSArray *)sortDescriptors;

@end
