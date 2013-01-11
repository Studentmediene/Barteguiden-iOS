//
//  Event.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.11.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "_Event.h"
#import <CoreLocation/CoreLocation.h>


// TODO: Update list
typedef NS_ENUM(NSInteger, EventCategory) {
    EventCategory1,
    EventCategory2,
    EventCategory3,
    EventCategory4
};


@protocol Event <NSObject>

@property (nonatomic, readonly) NSString *eventIdentifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *startAt;
@property (nonatomic, readonly) NSDate *endAt;

@property (nonatomic, readonly, getter=isFeatured) BOOL featured;
@property (nonatomic, getter=isFavorite) BOOL favorite;

@property (nonatomic, readonly) EventCategory category;
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


@interface Event : _Event <Event>

@end
