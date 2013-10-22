//
//  MapViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 23.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>


static CLLocationDistance const kMapViewLocationDistance = 500;

static CGSize const kCalloutButtonSize = {45, 45};
static NSString * const kPinAnnotationViewIdentifier = @"PinAnnotationView";


@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, getter = isLoading) BOOL loading;

@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // WORKAROUND: Delay the message to make the map view center around the annotation
    [self performSelector:@selector(setRegionAndAddAnnotation) withObject:nil afterDelay:0.0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.loading) {
        [self notifyDidDownloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationViewIdentifier];
    
    UIButton *mapsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapsButton.backgroundColor = self.view.tintColor;
    mapsButton.adjustsImageWhenHighlighted = NO;
    mapsButton.frame = CGRectMake(0, 0, kCalloutButtonSize.width, kCalloutButtonSize.height);
    [mapsButton setImage:[UIImage imageNamed:@"Car"] forState:UIControlStateNormal];
    [mapsButton addTarget:self action:@selector(fadeBackgroundColor:) forControlEvents:UIControlEventTouchDown];
    [mapsButton addTarget:self action:@selector(resetBackgroundColor:) forControlEvents:UIControlEventTouchCancel];
    
    annotationView.canShowCallout = YES;
    annotationView.leftCalloutAccessoryView = mapsButton;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CLLocationCoordinate2D coordinate = view.annotation.coordinate;
    NSString *address = view.annotation.subtitle;
    NSString *city = @"Trondheim";
    NSString *country = @"Norway";
    
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionaryWithDictionary:@{(NSString *)kABPersonAddressCityKey: city, (NSString *)kABPersonAddressCountryKey: country}];
    if (address != nil) {
        [addressDictionary setObject:address forKey:(NSString *)kABPersonAddressStreetKey];
    }
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:addressDictionary];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyWillDownloadData];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyDidDownloadData];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self notifyDidDownloadData];
    
    // TODO: Show error if loading fails?
}


#pragma mark - Private methods

- (void)setRegionAndAddAnnotation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.annotation coordinate], kMapViewLocationDistance, kMapViewLocationDistance);
    [self.mapView setRegion:region animated:NO];
    
    [self.mapView addAnnotation:self.annotation];
}

- (void)fadeBackgroundColor:(UIButton *)mapsButton
{
    mapsButton.backgroundColor = [self fadedColor];
}

- (void)resetBackgroundColor:(UIButton *)mapsButton
{
    mapsButton.backgroundColor = self.view.tintColor;
}

- (UIColor *)fadedColor
{
    return [UIColor colorWithHue:211/360.0 saturation:1 brightness:0.91 alpha:1];
}

- (void)notifyWillDownloadData
{
    self.loading = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:MapWillDownloadDataNotification object:self];
}

- (void)notifyDidDownloadData
{
    self.loading = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MapDidDownloadDataNotification object:self];
}

@end

// Notifications
NSString * const MapWillDownloadDataNotification = @"MapWillDownloadDataNotification";
NSString * const MapDidDownloadDataNotification = @"MapDidDownloadDataNotification";
