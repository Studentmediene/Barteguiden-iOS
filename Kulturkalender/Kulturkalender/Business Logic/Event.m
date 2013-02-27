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
    NSDictionary *categories = [self categories];
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

- (UIImage *)imageWithSize:(CGSize)size
{
    if (self.imageID == nil) { // TODO: Remove check
        return nil;
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    
    NSURL *url = [self.delegate URLForImageWithEventID:self.imageID size:scaledSize];
    
    UIImage *image = [self.imageCache imageForURL:url delegate:self];
    UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
    
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

- (NSDictionary *)categories
{
    static NSDictionary *categories;
    if (categories == nil) {
        categories = @{@"CATEGORY_CONCERTS": @(EventCategoryConcerts),
                       @"CATEGORY_NIGHTLIFE": @(EventCategoryNightlife),
                       @"CATEGORY_THEATRE": @(EventCategoryTheatre),
                       @"CATEGORY_DANCE": @(EventCategoryDance),
                       @"CATEGORY_ART_EXHIBITION": @(EventCategoryArtExhibition),
                       @"CATEGORY_SPORTS": @(EventCategorySports),
                       @"CATEGORY_PRESENTATIONS": @(EventCategoryPresentations)};
    }
    
    return categories;
}

@end
