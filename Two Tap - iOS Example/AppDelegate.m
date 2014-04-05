//
//  AppDelegate.m
//  Two Tap - iOS Example
//
//  Created by Radu Spineanu on 4/4/14.
//  Copyright (c) 2014 Radu Spineanu. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-bg.png"] forBarMetrics:UIBarMetricsDefault];
  
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

  
  return YES;
}
							

@end
