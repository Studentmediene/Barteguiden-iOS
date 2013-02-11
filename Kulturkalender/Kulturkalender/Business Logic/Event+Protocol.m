//
//  Event+Protocol.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event+Protocol.h"
#import "LocalizedText.h"

@implementation Event (Protocol)

@dynamic title;
@dynamic startAt;
@dynamic endAt;
@dynamic price;
@dynamic ageLimit;
@dynamic placeName;
@dynamic address;


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
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)descriptionForLanguage:(NSString *)language
{
    return [self localizedTextFromSet:self.localizedDescription withLanguage:language];
}

- (NSString *)featuredForLanguage:(NSString *)language
{
    return [self localizedTextFromSet:self.localizedFeatured withLanguage:language];
}


#pragma mark - Private methods

- (NSString *)localizedTextFromSet:(NSSet *)set withLanguage:(NSString *)language
{
    NSSet *currentLocalizedTexts = [set objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        LocalizedText *localizedText = obj;
        if ([localizedText.language isEqualToString:language]) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    return [[currentLocalizedTexts anyObject] text];
}

@end
