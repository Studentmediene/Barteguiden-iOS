//
//  EventProtocol.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.01.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSInteger, EventCategory) {
    EventCategoryConcerts = 0,
    EventCategoryNightlife,
    EventCategoryTheatre,
    EventCategoryDance,
    EventCategoryArtExhibition,
    EventCategorySports,
    EventCategoryPresentations,
    EventCategoryUnknown = -1
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

@property (nonatomic, readonly) NSString *placeName;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

- (UIImage *)imageWithSize:(CGSize)size;

- (NSString *)descriptionForLanguage:(NSString *)language;
- (NSString *)featuredForLanguage:(NSString *)language;

@end
