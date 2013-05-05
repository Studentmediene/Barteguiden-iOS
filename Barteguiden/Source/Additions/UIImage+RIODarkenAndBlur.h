//
//  UIImage+RIODarkenAndBlur.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 02.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RIODarkenAndBlur)

+ (UIImage *)darkenedAndBlurredImageForImage:(UIImage *)image withDarkenScale:(float)darkenScale blurRadius:(float)blueRadius;

@end
