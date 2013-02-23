//
//  EventResultsSectionInfo.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 22.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventResultsSectionInfo <NSObject>

// Accessing Objects
@property (nonatomic, readonly) NSUInteger numberOfEvents;
@property (nonatomic, readonly) NSArray *events;

// Accessing the Name and Title
@property (nonatomic, readonly) NSString *name;
//@property (nonatomic, readonly) NSString *indexTitle;

@end
