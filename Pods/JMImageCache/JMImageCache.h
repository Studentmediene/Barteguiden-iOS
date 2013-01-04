//
//  JMImageCache.h
//  JMCache
//
//  Created by Jake Marsh on 2/7/11.
//  Copyright 2011 Jake Marsh. All rights reserved.
//

#import "UIImageView+JMImageCache.h"

@class JMImageCache;

@protocol JMImageCacheDelegate <NSObject>

@optional
- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSURL *)url;

@end

@interface JMImageCache : NSCache

+ (JMImageCache *) sharedCache;

- (UIImage *) cachedImageForURL:(NSURL *)url;
- (void) imageForURL:(NSURL *)url completionBlock:(void (^)(UIImage *image))completion;
- (UIImage *) imageForURL:(NSURL *)url delegate:(id<JMImageCacheDelegate>)d;
- (UIImage *) imageFromDiskForURL:(NSURL *)url;

- (void) setImage:(UIImage *)i forURL:(NSURL *)url;
- (void) removeImageForURL:(NSString *)url;

- (void) writeData:(NSData *)data toPath:(NSString *)path;
- (void) performDiskWriteOperation:(NSInvocation *)invoction;

@end
