//
//  UIImage+RIODarkenAndBlur.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 02.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "UIImage+RIODarkenAndBlur.h"

@implementation UIImage (RIODarkenAndBlur)

// SOURCE: https://github.com/bryanjclark/ios-darken-image-with-cifilter

+ (UIImage *)darkenedAndBlurredImageForImage:(UIImage *)image withDarkenScale:(float)darkenScale blurRadius:(float)blurRadius
{
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // First, create some darkness
    CIFilter *blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor *black = [CIColor colorWithString:[NSString stringWithFormat:@"0.0 0.0 0.0 %f", darkenScale]];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage *blackImage = [blackGenerator valueForKey:@"outputImage"];
    
    // Second, apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:inputImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];
    
    // Third, blur the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@(blurRadius) forKey:@"inputRadius"];
    [blurFilter setValue:darkenedImage forKey:kCIInputImageKey];
    CIImage *blurredImage = [blurFilter outputImage];
    
    CGImageRef cgImage = [context createCGImage:blurredImage fromRect:inputImage.extent];
    UIImage *blurredAndDarkenedImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return blurredAndDarkenedImage;
}

@end
