//
//  RIOEvent.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


// TODO: Update list
typedef NS_ENUM(NSInteger, RIOEventCategory) {
    RIOEventCategory1,
    RIOEventCategory2,
    RIOEventCategory3,
    RIOEventCategory4
};


@protocol RIOEvent <NSObject>

@property (nonatomic, readonly) NSString *eventIdentifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *startAt;
@property (nonatomic, readonly) NSDate *endAt;

@property (nonatomic, readonly, getter=isfeatured) BOOL featured;
@property (nonatomic, getter=isFavorite) BOOL favorite;

@property (nonatomic, readonly) RIOEventCategory category;
@property (nonatomic, readonly) NSDecimalNumber *price;
@property (nonatomic, readonly) NSNumber *ageLimit;

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, readonly) UIImage *originalImage;

@property (nonatomic, readonly) NSString *placeName;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

- (NSString *)descriptionForLanguage:(NSString *)language;
- (NSString *)featuredForLanguage:(NSString *)language;

@end