//
//  EventFormatter+LocalizedText.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 26.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventFormatter.h"


@interface EventFormatter (LocalizedText)

- (NSString *)currentLocalizedDescription;
- (NSString *)currentLocalizedFeatured;

@end
