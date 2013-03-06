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

@property (nonatomic, weak) IBOutlet UITableViewCell *ageLimitAllEventsCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *ageLimitAllowedForMyAgeCell;
@property (nonatomic, weak) IBOutlet UITextField *myAgeTextField;

@property (nonatomic, weak) IBOutlet UITableViewCell *priceFilterAllEventsCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *priceFilterPaidEvents;
@property (nonatomic, weak) IBOutlet UITableViewCell *priceFilterFreeEvents;

@end
