//
//  EventFormatter+Location.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter+Location.h"
#import "EventConstants.h"
#import "EventKit.h"
#import "EventAnnotation.h"


@implementation EventFormatter (Location)

- (BOOL)hasLocation
{
    return CLLocationCoordinate2DIsValid([self.event location]);
}

- (id<MKAnnotation>)annotation
{
    CLLocationCoordinate2D location = [self.event location];
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    annotation.latitude = @(location.latitude);
    annotation.longitude = @(location.longitude);
    annotation.placeName = [self.event placeName];
    annotation.address = [self.event address];
    
    return annotation;
}

@end
