//
//  Event+TableView.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "ManagedEvent.h"

@interface ManagedEvent (TableView)

- (NSString *)dateSectionName;

- (NSString *)timeAndLocationString;

@end

// Constants
extern NSString * const kEventSectionName;