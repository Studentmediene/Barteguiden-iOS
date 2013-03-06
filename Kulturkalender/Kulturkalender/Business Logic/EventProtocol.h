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
    EventCategoryUnknown = -1,
    EventCategoryConcerts = 0,
    EventCategoryNightlife,
    EventCategoryTheatre,
    EventCategoryDance,
    EventCategoryArtExhibition,
    EventCategorySports,
    EventCategoryPresentations
};

@protocol Event <NSObject>

@property (nonatomic, readonly) NSString *eventID;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *startAt;
@property (nonatomic, readonly) NSDate *endAt;

@property (nonatomic, readonly, getter = isFeatured) BOOL featured;
@property (nonatomic, getter = isFavorite) BOOL favorite;

@property (nonatomic, readonly) EventCategory category;
@property (nonatomic, readonly) NSDecimalNumber *price;
@property (nonatomic, readonly) NSUInteger ageLimit;

@property (nonatomic, readonly) NSString *placeName;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, copy) NSString *calendarEventID;

- (UIImage *)imageWithSize:(CGSize)size;

- (NSString *)descriptionForLanguage:(NSString *)language;
- (NSString *)featuredForLanguage:(NSString *)language;

@end
