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

- (IBAction)closeModal:(id)sender;

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
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (BOOL)prefersStatusBarHidden {
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


- (void)keyboardWillShow:(NSNotification *)n
{
  self.closeButton.hidden = YES;
}

- (void)keyboardDidHide:(NSNotification *)n
{
  self.closeButton.hidden = NO;
}


- (IBAction)closeModal:(id)sender
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
