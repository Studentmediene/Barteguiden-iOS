//
//  MapViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@protocol MKAnnotation;

@interface MapViewController : UIViewController

@property (nonatomic, strong) id<MKAnnotation> annotation;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

// Notifications
extern NSString * const MapWillDownloadDataNotification;
extern NSString * const MapDidDownloadDataNotification;