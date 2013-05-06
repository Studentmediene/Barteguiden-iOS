//
//  DefaultAlertViewControllerDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 05.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlertChooser;


@protocol AlertChooserDelegate <NSObject>

- (void)alertChooserSelectionDidChange:(AlertChooser *)alertChooser;

@end
