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
	// Do any additional setup after loading the view.
    
    self.imageView.image = self.poster;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
