//
//  BuyViewController.m
//  Two Tap - iOS Example
//
//  Created by Radu Spineanu on 4/4/14.
//  Copyright (c) 2014 Radu Spineanu. All rights reserved.
//

#import "BuyViewController.h"

/*
  This is an example UIWebView Integration with Two Tap. It displays a top bar while the page loads
  to give the illusion of the interface being native.
 */

@interface BuyViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *ttWebView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (void)closeModal;

@end

@implementation BuyViewController

@synthesize productUrl;


- (void)viewDidLoad {
  [[self.ttWebView scrollView] setBounces: NO];
  
  NSString *encodedProductUrl = [self encodeUrlString:self.productUrl];
  
  // Load the POST creating form from the Two Tap desktop example with a custom CSS file:
  // https://github.com/sradu/twotap-web-example/blob/master/views/integration_iframe.ejs
  NSString *customCSSURL = @"http://localhost:2500/stylesheets/integration_twotap_ios.css";
  NSString *ttPath = [NSString stringWithFormat:@"http://localhost:2500/integration_iframe?custom_css_url=%@&product=%@",  customCSSURL, encodedProductUrl];
  
  NSURL *ttURL = [NSURL URLWithString:ttPath];
  NSURLRequest *ttRequestObj = [NSURLRequest requestWithURL:ttURL];
  [self.ttWebView loadRequest:ttRequestObj];
  
  // Show a loading indicator while we load the initial iframe.
  [self.loadingIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // Always check for postMessages from Two Tap.
  [self checkPostMessages];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // After the UIWebView finishes loading we can hide the fake top bar.
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    // Hide the loadingIndicator.
    [self.loadingIndicator stopAnimating];
  });
}


// Two Tap sends different postMessage events. We can catch interesting ones
// (like close_pressed, cart_finalized) here and performs actions based on them.
-(void)checkPostMessages {
  NSString *messagesJSON = [self.ttWebView stringByEvaluatingJavaScriptFromString:@"postMessagesJSON()"];
  
  NSArray *messages = [NSJSONSerialization
               JSONObjectWithData:[messagesJSON dataUsingEncoding:NSUTF8StringEncoding]
               options:0
               error:nil];
  
  for (NSDictionary *message in messages) {
    if ([message[@"action"] isEqual: @"close_pressed"]) {
      [self closeModal];
    }
  }

  if (self.isViewLoaded && self.view.window) {
    [self performSelector:@selector(checkPostMessages) withObject:nil afterDelay:0.3];
  }
}


- (void)closeModal {
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Your progress will be lost. Are you sure you want to close the checkout?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [message show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex != 1) {
    return;
  }
  
  [self dismissViewControllerAnimated:YES completion:NULL];
}


// Avoid opening Out of Stock and other outside links inside this UIWebView.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  // Whitelist URLs that can be opened inside this UIWebView. Like the URL to your opener iframe.
  NSArray *localURLs = @[@"checkout.twotap.com", @"localhost"];
  
  NSString *reqURL = request.URL.absoluteString;
  BOOL openInSafari = YES;
  
  for (NSString *url in localURLs) {
    if ([reqURL rangeOfString:url].location != NSNotFound ) {
      openInSafari = NO;
    }
  }
  
  if (openInSafari) {
    [[UIApplication sharedApplication] openURL:request.URL];
    return false;
  } else {
    return true;
  }
}


// URL encoding
- (NSString *)encodeUrlString:(NSString *)string {
  return CFBridgingRelease(
                           CFURLCreateStringByAddingPercentEscapes(
                                                                   kCFAllocatorDefault,
                                                                   (__bridge CFStringRef)string,
                                                                   NULL,
                                                                   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                   kCFStringEncodingUTF8)
                           );
}

@end
