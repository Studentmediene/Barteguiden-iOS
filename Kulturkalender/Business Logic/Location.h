//
//  Location.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) Event *event;

@end
