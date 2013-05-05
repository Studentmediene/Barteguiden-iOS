//
//  DefaultAlertViewControllerDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 05.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DefaultAlertViewController;
@class EKAlarm;


@protocol DefaultAlertViewControllerDelegate <NSObject>

- (void)defaultAlertViewController:(DefaultAlertViewController *)defaultAlertViewController didSelectAlert:(EKAlarm *)alert;

@end
