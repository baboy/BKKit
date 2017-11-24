//
//  AppBaseDelegate.h
//  iVideo
//
//  Created by baboy on 6/20/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppBaseDelegate : UIResponder
- (void)registerNotification;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(NSString *)buttonTitle,...;

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationDidBecomeActive:(UIApplication *)application ;
- (void)applicationWillTerminate:(UIApplication *)application ;
@end
