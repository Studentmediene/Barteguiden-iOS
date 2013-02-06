//
//  _LocalizedFeatured.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocalizedText.h"

@class _Event;

@interface LocalizedFeatured : LocalizedText

@property (nonatomic, retain) _Event *event;

@end
