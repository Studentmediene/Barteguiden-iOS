//
//  ApplicationNetworkActivity.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 13.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkActivity.h"


@interface ApplicationNetworkActivity : NSObject <NetworkActivity>

@property (nonatomic, readonly) UIApplication *application;

- (id)initWithApplication:(UIApplication *)application;

@end
