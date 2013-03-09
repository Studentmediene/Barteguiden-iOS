//
//  Event+Protocol.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event.h"
#import "EventDelegate.h"
#import "LocalizedText.h"


@implementation Event

@synthesize delegate=_delegate;
@synthesize imageCache=_imageCache;

- (JMImageCache *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [JMImageCache sharedCache];
    }
    
    return _imageCache;
}

- (NSUInteger)ageLimit
{
    return [self.ageLimitNumber unsignedIntegerValue];
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
    NSDictionary *categories = [self categoriesByKey];
    NSNumber *category = categories[self.categoryID];
    if (category != nil) {
        return [category integerValue];
    }
    
    return EventCategoryUnknown;
}

- (CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSURL *)URL
{
    return [NSURL URLWithString:self.eventURL];
}

- (UIImage *)imageWithSize:(CGSize)size
{
    NSLog(@"Retrieving image for eventID:%@", self.eventID);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    
    NSString *imageID = [NSString stringWithFormat:@"img%@", self.eventID];
    NSURL *url = [self.delegate URLForImageWithEventID:imageID size:scaledSize];
    
    UIImage *image = [self.imageCache imageForURL:url delegate:self];
    
    UIImage *scaledImage = nil;
    if (image != nil) {
        scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
    }
    
    return scaledImage;
}

- (NSString *)descriptionForLanguage:(NSString *)language
{
    return [self localizedTextFromSet:self.localizedDescription withLanguage:language];
}

- (NSString *)featuredForLanguage:(NSString *)language
{
    return [self localizedTextFromSet:self.localizedFeatured withLanguage:language];
}


#pragma mark - JMImageCacheDelegate

- (void)cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSURL *)url
{
    NSLog(@"Image downloaded");
    [self.delegate eventDidChange:self];
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

- (NSDictionary *)categoriesByKey
{
    static NSDictionary *categories;
    if (categories == nil) {
        categories = @{@"CONCERTS": @(EventCategoryConcerts),
                       @"NIGHTLIFE": @(EventCategoryNightlife),
                       @"THEATRE": @(EventCategoryTheatre),
                       @"DANCE": @(EventCategoryDance),
                       @"ART_EXHIBITION": @(EventCategoryArtExhibition),
                       @"SPORTS": @(EventCategorySports),
                       @"PRESENTATIONS": @(EventCategoryPresentations)};
    }
    
    return categories;
}

@end
