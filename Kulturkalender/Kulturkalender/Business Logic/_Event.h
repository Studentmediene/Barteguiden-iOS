//
//  _Event.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class _LocalizedDescription, _LocalizedFeatured;

@interface _Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * ageLimit;
@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSDate * endAt;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * featured;
@property (nonatomic, retain) NSString * imageID;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSDate * startAt;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *localizedDescription;
@property (nonatomic, retain) NSSet *localizedFeatured;
@end

@interface _Event (CoreDataGeneratedAccessors)

- (void)addLocalizedDescriptionObject:(_LocalizedDescription *)value;
- (void)removeLocalizedDescriptionObject:(_LocalizedDescription *)value;
- (void)addLocalizedDescription:(NSSet *)values;
- (void)removeLocalizedDescription:(NSSet *)values;

- (void)addLocalizedFeaturedObject:(_LocalizedFeatured *)value;
- (void)removeLocalizedFeaturedObject:(_LocalizedFeatured *)value;
- (void)addLocalizedFeatured:(NSSet *)values;
- (void)removeLocalizedFeatured:(NSSet *)values;

@end
