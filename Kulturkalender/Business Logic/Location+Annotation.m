//
//  Location+Annotation.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Location+Annotation.h"

@implementation Location (Annotation)

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title
{
    return self.placeName;
}

- (NSString *)subtitle
{
    return self.address;
}

@end
