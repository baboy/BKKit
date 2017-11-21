//
//  AppBaseViewController.h
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIViewController.h"
/*
@interface AppNavigitionController : XUINavigationController
@property (nonatomic, assign) id rootController;
@end
*/
@interface BaseViewController : XUIViewController
@property (nonatomic, assign) BOOL canPullBack;

- (void)commentApp;
- (void)checkAppViersion;
- (NSInteger)currentAppUpdateRole:(id)app;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
