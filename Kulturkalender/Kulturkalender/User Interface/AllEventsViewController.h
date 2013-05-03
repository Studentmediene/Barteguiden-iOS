//
//  AllEventsViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "AbstractEventsViewController.h"

@interface AllEventsViewController : AbstractEventsViewController

@property (nonatomic, weak) IBOutlet UISegmentedControl *priceFilterSegmentedControl;

- (IBAction)changePriceFilter:(id)sender;

@end
