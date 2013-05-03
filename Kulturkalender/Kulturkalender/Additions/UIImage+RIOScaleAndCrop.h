//
//  UIImage+RIOScaleAndCrop.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 28.03.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>


// Source: http://stackoverflow.com/questions/603907/uiimage-resize-then-crop

@interface UIImage (RIOScaleAndCrop)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
