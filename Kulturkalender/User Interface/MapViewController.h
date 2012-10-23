//
//  MapViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MKMapView;
@protocol MKAnnotation;

@interface MapViewController : UIViewController

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) id<MKAnnotation> annotation;

@end
