//
//  ApplicationNetworkActivity.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 13.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "ApplicationNetworkActivity.h"


@interface ApplicationNetworkActivity ()

@property (nonatomic, strong) UIApplication *application;
@property (nonatomic) NSUInteger networkActivityCount;

@end


@implementation ApplicationNetworkActivity

- (id)initWithApplication:(UIApplication *)application
{
    self = [super init];
    if (self) {
        _application = application;
    }
    return self;
}

- (void)incrementNetworkActivity
{
    self.networkActivityCount++;
    
    [self updateNetworkActivityIndicator];
}

- (void)decrementNetworkActivity
{
    if (self.networkActivityCount > 0) {
        self.networkActivityCount--;
    }
    
    [self updateNetworkActivityIndicator];
}


#pragma mark - Private methods

- (void)updateNetworkActivityIndicator
{
    BOOL shouldShowNetworkActivity = (self.networkActivityCount > 0);
    [self.application setNetworkActivityIndicatorVisible:shouldShowNetworkActivity];
}

@end
