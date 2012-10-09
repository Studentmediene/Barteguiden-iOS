//
//  Event.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * ageLimit;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSManagedObject *location;

@end
