//
//  _Event.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalizedDescription, LocalizedFeatured;

@interface _Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * ageLimitNumber;
@property (nonatomic, retain) NSString * calendarEventID;
@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventURL;
@property (nonatomic, retain) NSNumber * favoriteState;
@property (nonatomic, retain) NSNumber * featuredState;
@property (nonatomic, retain) NSString * imageID;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSDate * startAt;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *localizedDescription;
@property (nonatomic, retain) NSSet *localizedFeatured;
@end

@interface _Event (CoreDataGeneratedAccessors)

- (void)addLocalizedDescriptionObject:(LocalizedDescription *)value;
- (void)removeLocalizedDescriptionObject:(LocalizedDescription *)value;
- (void)addLocalizedDescription:(NSSet *)values;
- (void)removeLocalizedDescription:(NSSet *)values;

- (void)addLocalizedFeaturedObject:(LocalizedFeatured *)value;
- (void)removeLocalizedFeaturedObject:(LocalizedFeatured *)value;
- (void)addLocalizedFeatured:(NSSet *)values;
- (void)removeLocalizedFeatured:(NSSet *)values;

@end
