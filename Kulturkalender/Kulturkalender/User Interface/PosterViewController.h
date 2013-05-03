//
//  PosterViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 06.03.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PosterViewController : UIViewController

@property (nonatomic, strong) UIImage *poster;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
