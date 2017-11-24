//
//  AppBaseViewController.m
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseViewController.h"
#import "BKKitDefines.h"
#import "UIViewController+x.h"
#import "DBCache.h"
#import "Application.h"
#import "NSString+x.h"
#import "App.h"
#import "AppContext.h"

#define AlertViewTagCheckVersion     11
#define AlertViewCommentApp 20
#define AlertViewCommentAppGoodIndex    2

@interface BaseViewController ()
@property (nonatomic, retain) ApplicationVersion *app;
@end

@implementation BaseViewController
- (void)dealloc{
    //[super dealloc];
    ////
}

- (void)checkAppViersion{
    [ApplicationVersion getAppVersionSuccess:^(id task, ApplicationVersion *app) {
        self.app = app;
        NSString *msg = app.msg;
        NSMutableArray *btnTitles = [NSMutableArray array];
        switch ([self currentAppUpdateRole:app]) {
            case AppUpdateRoleMsg:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRolePrompt:
                [btnTitles addObject:NSLocalizedString(@"取消", nil)];
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRoleUpdate:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRoleForbidden:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
                
            default:
                break;
        }
        if (btnTitles.count>0) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
            alert.tag = AlertViewTagCheckVersion;
            alert.message = msg;
            for (int i = 0, n = (int)btnTitles.count; i < n; i++) {
                [alert addButtonWithTitle:[btnTitles objectAtIndex:i]];
            }
            [alert show];
            
        }

    }
                                     failure:^(id task, ApplicationVersion *app, NSError *error) {
                                         
                                     }];
}

- (void)commentApp{
    int t = get_current_app_start_times();
    NSString *commentMsg = [DBCache valueForKey:@"app_store_comment_msg"];
    if ( (t>0 && t%3==0) && !get_current_app_comment() && (AppStore && [AppStore isURL]) && [commentMsg length]>10) {
        UIAlertView *alert = [self alertWithTitle:nil
                                          message:commentMsg
                                           button:NSLocalizedString(@"太烂了,不评", nil),
                              NSLocalizedString(@"一般般,不评", nil),
                              NSLocalizedString(@"挺好的,好评", nil),
                              NSLocalizedString(@"取消", nil),nil];
        alert.tag = AlertViewCommentApp;
    }
}
- (NSInteger)currentAppUpdateRole:(ApplicationVersion*)app{
    if ([app.role intValue]>0) {
        return [self.app.role intValue];
    }
    return AppUpdateRoleNormal;
}
#pragma  alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag){
        case AlertViewTagCheckVersion:{
            NSString *updateUrl = [self.app.appStore isURL]?self.app.appStore:self.app.downloadUrl;
            switch ([self currentAppUpdateRole:self.app]) {
                case AppUpdateRolePrompt:
                    if (buttonIndex==1 && [updateUrl isURL]) {
                        [APP openURL:[NSURL URLWithString:updateUrl]];
                    }
                    break;
                case AppUpdateRoleUpdate:
                    if ([updateUrl isURL]) {
                        [APP openURL:[NSURL URLWithString:updateUrl]];
                    }
                    break;
                case AppUpdateRoleForbidden:
                    exit(-1);
                    break;
                    
                default:
                    break;
            }
        }
        case AlertViewCommentApp:
            //[BehaviorTracker trackEvent:@"comment_app" group:@"app" element:[NSString stringWithFormat:@"%ld", (long)buttonIndex]];
            if (buttonIndex == AlertViewCommentAppGoodIndex) {
                DLOG(@"%@",AppStore);
                [APP openURL:[NSURL URLWithString:AppStore]];
            }
            if (buttonIndex!=3) {
                set_current_app_comment((int)buttonIndex+1);
            }
            break;
    }
}
@end
