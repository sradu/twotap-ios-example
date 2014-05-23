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

@property (weak, nonatomic) IBOutlet UIView *loadingTopBarView;

@property (weak, nonatomic) IBOutlet UILabel *loadingTopBarTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (void)closeModal;

@end

@implementation BuyViewController

@synthesize productUrl;

- (void)viewDidLoad
{
  [[self.ttWebView scrollView] setBounces: NO];
  
  NSString *customCSSURL = @"http://localhost:2500/stylesheets/integration_twotap_ios.css";
  
  NSString *ttPath = [NSString stringWithFormat:@"http://localhost:2500/integration_iframe?custom_css_url=%@&product=%@",  customCSSURL, self.productUrl];
  
  NSURL *ttURL = [NSURL URLWithString:ttPath];
  NSURLRequest *ttRequestObj = [NSURLRequest requestWithURL:ttURL];
  [self.ttWebView loadRequest:ttRequestObj];
  
  self.loadingIndicator.layer.cornerRadius = 6;
  
  [self.loadingIndicator startAnimating];
  
  [self checkPostMessages];
}


- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [self.loadingIndicator stopAnimating];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    
    self.loadingTopBarView.hidden = YES;
    self.loadingTopBarTitleLabel.hidden = YES;
  });
}



-(void)checkPostMessages
{
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
  
  [self performSelector:@selector(checkPostMessages) withObject:nil afterDelay:0.3];
}

- (void)closeModal
{
  
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Your progress will be lost. Are you sure you want to close the checkout?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [message show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != 1) {
    return;
  }
  
  [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
