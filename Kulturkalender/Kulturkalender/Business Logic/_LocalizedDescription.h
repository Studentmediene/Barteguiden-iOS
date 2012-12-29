//
//  _LocalizedDescription.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 29.12.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "_LocalizedText.h"

@class _Event;

@interface _LocalizedDescription : _LocalizedText

@property (nonatomic, retain) _Event *event;

@end
