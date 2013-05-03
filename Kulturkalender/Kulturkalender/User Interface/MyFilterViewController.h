//
//  MyPageViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 04.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"

@protocol FilterManager;

@interface MyFilterViewController : AbstractEventsViewController

@property (nonatomic, strong) id<FilterManager> filterManager;

@end
