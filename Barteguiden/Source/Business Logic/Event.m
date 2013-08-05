//
//  Event+Protocol.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "Event.h"
#import "EventDelegate.h"
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

- (BOOL)hasLocation
{
    return (self.latitude != nil && self.longitude != nil);
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
    
    NSURL *url = [NSURL URLWithString:self.imageURL];
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
    
    NSURL *url = [NSURL URLWithString:self.imageURL];
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
    if ([language isEqualToString:@"nb"]) {
        return self.description_nb;
    }
    else if ([language isEqualToString:@"en"])
    {
        return self.description_en;
    }
    
    return nil;
}


#pragma mark - JMImageCacheDelegate

- (void)cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSURL *)url
{
    NSLog(@"Image downloaded");
    [self.delegate eventDidChange:self];
}

@end
