//
//  EventAnnotation.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventAnnotation.h"
#import "EventKit.h"


@interface EventAnnotation ()

@property (nonatomic, strong) id<Event> event;

@end


@implementation EventAnnotation

- (id)initWithEvent:(id<Event>)event
{
    self = [super init];
    if (self) {
        _event = event;
    }
    return self;
}


#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return [self.event location];
}

- (NSString *)title
{
    return [self.event placeName];
}

- (NSString *)subtitle
{
    return [self.event address];
}

@end
