//
//  WebsiteViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "WebsiteViewController.h"
#import <PSPDFActionSheet.h>
#import <PSPDFAlertView.h>


static CGFloat kRefreshBarButtonItemWidth = 18;


@interface WebsiteViewController ()

@property (nonatomic, strong) UIBarButtonItem *activityIndicatorViewBarButtonItem;
@property (nonatomic) BOOL lastLoading;

@end


@implementation WebsiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateBackAndForwardButtons];
    
    self.webView.scalesPageToFit = YES;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vg.no"]];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void)back:(id)sender
{
    [self.webView goBack];
}

- (void)forward:(id)sender
{
    [self.webView goForward];
}

- (void)refresh:(id)sender
{
    [self.webView loadRequest:self.webView.request];
}

- (void)share:(id)sender
{
    NSString *openInSafariTitle = NSLocalizedString(@"Open in Safari", nil);
    NSString *copyLinkTitle = NSLocalizedString(@"Copy Link", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    PSPDFActionSheet *shareActionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    [shareActionSheet addButtonWithTitle:openInSafariTitle block:^{
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }];
    [shareActionSheet addButtonWithTitle:copyLinkTitle block:^{
        [[UIPasteboard generalPasteboard] setURL:self.webView.request.URL];
    }];
    [shareActionSheet setCancelButtonWithTitle:cancelTitle block:NULL];
    [shareActionSheet showWithSender:sender fallbackView:self.view animated:YES];
}


#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed:%@", error);
//    NSString *title = NSLocalizedString(@"Cannot Open Page", nil);
//    NSString *message = NSLocalizedString(@"Safari cannot open the page because the address is invalid", nil);
//    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
//    PSPDFAlertView *failedAlertView = [[PSPDFAlertView alloc] initWithTitle:title message:message];
//    [failedAlertView setCancelButtonWithTitle:cancelButtonTitle block:NULL];
//    [failedAlertView show];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateRefreshButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateBackAndForwardButtons];
    [self updateRefreshButton];
}


#pragma mark - Private methods

- (void)updateBackAndForwardButtons
{
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
}

- (void)updateRefreshButton
{
    UIBarButtonItem *currentBarButtonItem = nil;
    UIBarButtonItem *replacementBarButtonItem = nil;
    if (self.webView.loading == YES && self.lastLoading == NO) {
        currentBarButtonItem = self.refreshBarButtonItem;
        replacementBarButtonItem = self.activityIndicatorViewBarButtonItem;
    }
    else if (self.webView.loading == NO && self.lastLoading == YES) {
        currentBarButtonItem = self.activityIndicatorViewBarButtonItem;
        replacementBarButtonItem = self.refreshBarButtonItem;
    }
    else {
        return;
    }
    
    NSMutableArray *items = [self.toolbar.items mutableCopy];
    NSUInteger currentIndex = [items indexOfObject:currentBarButtonItem];
    [items replaceObjectAtIndex:currentIndex withObject:replacementBarButtonItem];
    self.toolbar.items = [items copy];
//    self.refreshBarButtonItem = (self.webView.loading == YES) ? self.activityIndicatorViewBarButtonItem : self.originalRefreshBarButtonItem;
    
    self.lastLoading = self.webView.loading;
}

- (UIBarButtonItem *)activityIndicatorViewBarButtonItem
{
    static UIBarButtonItem *barButtonItem = nil;
    if (barButtonItem == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [activityIndicatorView sizeToFit];
        [activityIndicatorView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [activityIndicatorView startAnimating];
        
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        barButtonItem.width = kRefreshBarButtonItemWidth;
    }
    
    return barButtonItem;
}

@end
