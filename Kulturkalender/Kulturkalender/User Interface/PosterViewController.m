//
//  PosterViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 06.03.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "PosterViewController.h"


@implementation PosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromCGSize(self.poster.size));
    self.imageView.frame = CGRectMake(0, 0, self.poster.size.width, self.poster.size.height);
    self.imageView.image = self.poster;
    self.scrollView.contentSize = self.poster.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
