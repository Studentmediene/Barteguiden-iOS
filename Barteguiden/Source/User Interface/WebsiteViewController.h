//
//  WebsiteViewController.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebsiteViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareBarButtonItem;

- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)refreshOrStop:(id)sender;
- (IBAction)share:(id)sender;

@property (nonatomic, strong) NSURL *openURL;

@end

// Notifications
extern NSString * const WebsiteWillDownloadDataNotification;
extern NSString * const WebsiteDidDownloadDataNotification;