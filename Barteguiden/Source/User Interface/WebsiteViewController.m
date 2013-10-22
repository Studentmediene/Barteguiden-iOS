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


@interface WebsiteViewController ()

@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;

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
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.openURL];
    [self.webView loadRequest:urlRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.webView.loading == YES) {
        NSLog(@"Should stop");
        [self notifyDidDownloadData]; // WORKAROUND: For some reason, -stopLoading does not trigger -webView:didFailLoadWithError: in this context
        [self.webView stopLoading];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

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
    if (self.webView.loading == NO) {
        [self.webView loadRequest:self.webView.request];
    }
    else {
        [self.webView stopLoading];
    }
}

- (void)share:(id)sender
{
    NSString *openInSafariTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_OPEN_IN_SAFARI_BUTTON", nil, [NSBundle mainBundle], @"Open in Safari", @"Title of button to open website in Safari in alert sheet (Displayed when browsing the event's website)");
    NSString *copyLinkTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_COPY_LINK_BUTTON", nil, [NSBundle mainBundle], @"Copy Link", @"Title of button to copy link to website in alert sheet (Displayed when browsing the event's website)");
    NSString *cancelTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"Cancel", @"Title of cancel button in alert sheet (Displayed when browsing the event's website)");
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateRefreshButton];
    
    [self notifyWillDownloadData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self notifyDidDownloadData];
    
    [self updateBackAndForwardButtons];
    [self updateRefreshButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self notifyDidDownloadData];
    
    [self updateRefreshButton];
    
    BOOL userCancelled = ([error code] == NSURLErrorCancelled);
    if (userCancelled == NO) {
        NSString *title = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_TITLE", nil, [NSBundle mainBundle], @"Cannot Open Page", @"Title of alert view (Displayed when browser failed to load)");
        NSString *message = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_MESSAGE", nil, [NSBundle mainBundle], @"Safari cannot open the page because the address is invalid", @"Message of alert view (Displayed when browser failed to load)");
        NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"OK", @"Title of cancel button in alert view (Displayed when browser failed to load)");
        PSPDFAlertView *failedAlertView = [[PSPDFAlertView alloc] initWithTitle:title message:message];
        [failedAlertView setCancelButtonWithTitle:cancelButtonTitle block:NULL];
        [failedAlertView show];
    }
}


#pragma mark - Private methods

- (void)updateBackAndForwardButtons
{
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
}

- (void)updateRefreshButton
{
    NSUInteger refreshBarButtonItemIndex = [self.toolbar.items indexOfObject:self.refreshBarButtonItem];
    NSUInteger stopBarButtonItemIndex = [self.toolbar.items indexOfObject:self.stopBarButtonItem];
    
    UIBarButtonItem *replacementBarButtonItem = nil;
    NSUInteger replacementIndex;
    
    if (self.webView.loading == NO && refreshBarButtonItemIndex == NSNotFound) {
        replacementBarButtonItem = self.refreshBarButtonItem;
        replacementIndex = stopBarButtonItemIndex;
    }
    else if (self.webView.loading == YES && stopBarButtonItemIndex == NSNotFound) {
        replacementBarButtonItem = self.stopBarButtonItem;
        replacementIndex = refreshBarButtonItemIndex;
    }
    else {
        return;
    }

    NSMutableArray *items = [self.toolbar.items mutableCopy];
    [items replaceObjectAtIndex:replacementIndex withObject:replacementBarButtonItem];
    self.toolbar.items = [items copy];
}

- (UIBarButtonItem *)stopBarButtonItem
{
    static UIBarButtonItem *barButtonItem = nil;
    if (barButtonItem == nil) {
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(refresh:)];
    }
    
    return barButtonItem;
}

- (void)notifyWillDownloadData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WebsiteWillDownloadDataNotification object:self];
}

- (void)notifyDidDownloadData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WebsiteDidDownloadDataNotification object:self];
}

@end

// Notifications
NSString * const WebsiteWillDownloadDataNotification = @"WebsiteWillDownloadDataNotification";
NSString * const WebsiteDidDownloadDataNotification = @"WebsiteDidDownloadDataNotification";
