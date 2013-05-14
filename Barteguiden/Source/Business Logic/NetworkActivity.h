//
//  NetworkActivity.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 13.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NetworkActivity <NSObject>

- (void)incrementNetworkActivity;
- (void)decrementNetworkActivity;

@end
