//
//  Event+LocalizedText.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "ManagedEvent.h"

@interface ManagedEvent (LocalizedText)

- (NSString *)currentLocalizedDescription;
- (NSString *)currentLocalizedFeatured;

@end
