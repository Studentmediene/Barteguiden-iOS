//
//  EventsSearchDisplayControllerDelegate.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventsSearchDisplayControllerDelegate <NSObject>

- (NSPredicate *)predicate;
- (void)navigateTo:(id)item;

@end
