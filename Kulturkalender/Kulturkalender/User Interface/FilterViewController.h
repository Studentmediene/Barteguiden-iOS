//
//  FilterViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 31.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterManager;

@interface FilterViewController : UITableViewController

@property (nonatomic, strong) id<FilterManager> filterManager;

@property (nonatomic, strong) IBOutlet UITableViewCell *ageLimitAllEventsCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *ageLimitAllowedForMyAgeCell;
@property (nonatomic, strong) IBOutlet UITextField *myAgeTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *priceFilterAllEventsCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *priceFilterPaidEvents;
@property (nonatomic, strong) IBOutlet UITableViewCell *priceFilterFreeEvents;

@end
