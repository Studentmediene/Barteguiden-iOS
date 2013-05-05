//
//  DefaultAlertViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 05.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DefaultAlertViewControllerDelegate;


@interface DefaultAlertViewController : UITableViewController

@property (nonatomic, weak) id<DefaultAlertViewControllerDelegate> delegate;

@property (nonatomic) NSTimeInterval selectedTimeInterval;

@end
