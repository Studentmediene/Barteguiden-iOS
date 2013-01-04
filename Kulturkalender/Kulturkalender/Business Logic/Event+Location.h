//
//  Event+Location.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "ManagedEvent.h"

@protocol MKAnnotation;

@interface ManagedEvent (Location)

- (BOOL)hasLocation;
- (id<MKAnnotation>)annotation;

@end
