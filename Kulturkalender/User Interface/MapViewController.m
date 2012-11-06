//
//  MapViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

const CLLocationDistance kMapViewLocationDistance = 500;

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // HACK: Delay the message to make the map view center around the annotation
    [self performSelector:@selector(setRegionAndAddAnnotation) withObject:nil afterDelay:0.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)setRegionAndAddAnnotation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.annotation coordinate], kMapViewLocationDistance, kMapViewLocationDistance);
    [self.mapView setRegion:region animated:NO];
    
    [self.mapView addAnnotation:self.annotation];
}

@end
