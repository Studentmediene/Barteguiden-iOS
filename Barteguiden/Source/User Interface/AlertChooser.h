//
//  DefaultAlertViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 05.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertChooserDelegate;
@class EKAlarm;


@interface AlertChooser : UITableViewController

@property (nonatomic, weak) id<AlertChooserDelegate> delegate;

@property (nonatomic) EKAlarm *selectedAlert;

@end
