//
//  EventAnnotation.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@protocol Event;

@interface EventAnnotation : NSObject <MKAnnotation>

- (id)initWithEvent:(id<Event>)event;

@end
