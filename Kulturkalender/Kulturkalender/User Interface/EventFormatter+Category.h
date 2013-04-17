//
//  EventFormatter+Category.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"
#import "EventKit.h"


@interface EventFormatter (Category)

- (NSString *)categoryString;
+ (NSString *)categoryStringForCategory:(EventCategory)category;
- (UIImage *)categoryImage;
+ (UIImage *)categoryImageForCategory:(EventCategory)category;
- (UIImage *)categoryBigImage;
+ (UIImage *)categoryBigImageForCategory:(EventCategory)category;

@end
