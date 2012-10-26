//
//  Event+Category.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Event (Category)

+ (NSArray *)categoryIDs;
+ (NSString *)stringForCategoryID:(NSNumber *)categoryID;

- (NSString *)categoryString;

@end
