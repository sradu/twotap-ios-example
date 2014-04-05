//
//  DetailViewController.m
//  Two Tap - iOS Example
//
//  Created by Radu Spineanu on 4/4/14.
//  Copyright (c) 2014 Radu Spineanu. All rights reserved.
//

#import "DetailViewController.h"
#import "BuyViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  [self setNeedsStatusBarAppearanceUpdate];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
  if ([segue.identifier isEqual:@"checkout"]) {
    BuyViewController *vc = (BuyViewController *)segue.destinationViewController;
    vc.productUrl = @"http://www.nastygal.com/clothes-dresses/reverse-acid-dress";
    
  } else {
    NSAssert(NO, @"Unknown segue. All segues must be handled.");
  }
}

@end
