//
//  Event+Location.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Location.h"
#import "EventAnnotation.h"

@implementation ManagedEvent (Location)

- (BOOL)hasLocation
{
    return (self.latitude != nil && self.longitude != nil);
}

- (id<MKAnnotation>)annotation
{
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    annotation.latitude = self.latitude;
    annotation.longitude = self.longitude;
    annotation.placeName = self.placeName;
    annotation.address = self.address;
    
    return annotation;
}

@end
