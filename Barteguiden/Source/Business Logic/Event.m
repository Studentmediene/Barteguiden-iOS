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
#import <JMImageCache/JMImageCache.h>


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

- (UIImage *)imageWithSize:(CGSize)size
{
    NSLog(@"Retrieving image for eventID:%@ (%.0fx%.0f)", self.eventID, size.width, size.height);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    
    NSURL *url = [NSURL URLWithString:self.imageURL];
    UIImage *image = [self.imageCache cachedImageForURL:url];
    if (image == nil) {
        [self.delegate eventStartedDownloadingData:self];
        __weak typeof(self) bself = self;
        [self.imageCache imageForURL:url completionBlock:^(UIImage *image) {
            [bself.delegate eventFinishedDownloadingData:self];
            [bself.delegate eventDidChange:self];
        } failureBlock:^(NSURLRequest *request, NSURLResponse *response, NSError *error) {
            [bself.delegate eventFinishedDownloadingData:self];
        }];
        
        return nil;
    }
    
    UIImage *scaledAndCroppedImage = [image imageByScalingAndCroppingForSize:scaledSize];
    UIImage *adjustedImage = [[UIImage alloc] initWithCGImage:scaledAndCroppedImage.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return adjustedImage;
}

- (NSString *)descriptionForLanguage:(NSString *)language
{
    if ([language isEqualToString:@"nb"]) {
        return self.description_nb;
    }
    else if ([language isEqualToString:@"en"]) {
        return self.description_en;
    }
    
    return nil;
}

@end
