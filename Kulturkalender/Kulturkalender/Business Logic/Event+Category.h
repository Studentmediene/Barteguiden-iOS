//
//  Event+Category.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 24.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedEvent.h"

@interface ManagedEvent (Category)

+ (NSArray *)categoryIDs;
+ (NSString *)stringForCategoryID:(NSNumber *)categoryID;

- (NSString *)categoryString;

@end
