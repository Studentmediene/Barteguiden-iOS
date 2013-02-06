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
    return self.eventID;
}

- (BOOL)isFeatured
{
    return [self.featuredState boolValue];
}

- (BOOL)isFavorite
{
    return [self.favoriteState boolValue];
}

- (void)setFavorite:(BOOL)favorite
{
    self.favoriteState = @(favorite);
}

- (EventCategory)category
{
    return 0; // TODO: Fix
}

- (UIImage *)thumbnailImage
{
    return nil; // TODO: Fix
}

- (UIImage *)originalImage
{
    return nil; // TODO: Fix
}

- (CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D location;
    return location; // TODO: Fix
}

- (NSString *)descriptionForLanguage:(NSString *)language
{
    return [NSString stringWithFormat:@"DESCRIPTION:%@", language]; // TODO: Fix
}

- (NSString *)featuredForLanguage:(NSString *)language
{
    return [NSString stringWithFormat:@"FEATURED:%@", language]; // TODO: Fix
}

@end
