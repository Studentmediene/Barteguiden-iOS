//
//  Event.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event.h"

@implementation Event

- (NSString *)eventIdentifier
{
    return nil;
}

- (NSString *)title
{
    return nil;
}

- (NSDate *)startAt
{
    return nil;
}

- (NSDate *)endAt
{
    return nil;
}

- (BOOL)isFeatured
{
    return YES;
}

- (BOOL)isFavorite
{
    return YES;
}

- (void)setFavorite:(BOOL)favorite
{
    
}

- (EventCategory)category
{
    return 0;
}

- (NSDecimalNumber *)price
{
    return [NSDecimalNumber zero];
}

- (NSNumber *)ageLimit
{
    return @0;
}

- (UIImage *)thumbnailImage
{
    return nil;
}

- (UIImage *)originalImage
{
    return nil;
}

- (NSString *)placeName
{
    return nil;
}

- (NSString *)address
{
    return nil;
}

- (CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D location;
    return location;
}

- (NSString *)descriptionForLanguage:(NSString *)language
{
    return nil;
}

- (NSString *)featuredForLanguage:(NSString *)language
{
    return nil;
}

@end
