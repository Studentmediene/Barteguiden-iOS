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
#import "UIImage+RIOScaleAndCrop.h" // TODO: Temp


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
    return [self.categoryID integerValue];
}

- (CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSURL *)URL
{
    return [NSURL URLWithString:self.eventURL];
}

- (UIImage *)originalImage
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    NSString *imageID = [NSString stringWithFormat:@"%@", self.eventID];
    NSURL *url = [self.delegate URLForImageWithEventID:imageID size:CGSizeZero];
    
    UIImage *image = [self.imageCache imageForURL:url delegate:self];
    
    if (image != nil) {
        UIImage *adjustedImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
        
        return adjustedImage;
    }
    
    return nil;
}

- (UIImage *)imageWithSize:(CGSize)size
{
    NSLog(@"Retrieving image for eventID:%@ (%.0fx%.0f)", self.eventID, size.width, size.height);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    
    NSString *imageID = [NSString stringWithFormat:@"%@", self.eventID];
    NSURL *url = [self.delegate URLForImageWithEventID:imageID size:scaledSize];
    
    UIImage *image = [self.imageCache imageForURL:url delegate:self];
    
    if (image != nil) {
        UIImage *scaledAndCroppedImage = [image imageByScalingAndCroppingForSize:scaledSize];
        UIImage *adjustedImage = [[UIImage alloc] initWithCGImage:scaledAndCroppedImage.CGImage scale:scale orientation:UIImageOrientationUp];
        
        return adjustedImage;
    }
    
    return nil;
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

@end
