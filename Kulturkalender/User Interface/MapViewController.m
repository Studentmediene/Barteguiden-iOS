//
//  MapViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

const CLLocationDistance kMapViewLocationDistance = 2000;

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self locateAndAddAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)locateAndAddAnnotation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.annotation coordinate], kMapViewLocationDistance, kMapViewLocationDistance);
    [self.mapView setRegion:region animated:NO];
    
    [self.mapView addAnnotation:self.annotation];
}

@end
