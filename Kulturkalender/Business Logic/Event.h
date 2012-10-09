//
//  Event.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalizedDescription, Location;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * ageLimit;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * timeStartAt;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSDate * timeCreatedAt;
@property (nonatomic, retain) NSDate * timeModifiedAt;
@property (nonatomic, retain) NSDate * timeEndAt;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *localizedDescription;
@property (nonatomic, retain) NSSet *localizedFeatured;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addLocalizedDescriptionObject:(LocalizedDescription *)value;
- (void)removeLocalizedDescriptionObject:(LocalizedDescription *)value;
- (void)addLocalizedDescription:(NSSet *)values;
- (void)removeLocalizedDescription:(NSSet *)values;

- (void)addLocalizedFeaturedObject:(NSManagedObject *)value;
- (void)removeLocalizedFeaturedObject:(NSManagedObject *)value;
- (void)addLocalizedFeatured:(NSSet *)values;
- (void)removeLocalizedFeatured:(NSSet *)values;

@end
