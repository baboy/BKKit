//
//  UIViewController+x.h
//  Pods
//
//  Created by baboy on 1/27/16.
//
//

#import <UIKit/UIKit.h>


enum{
    AlertViewTagAlert,
    AlertViewTagError,
};
extern BOOL checkInput(NSArray *conf,id delegate);
@interface UIViewController(x)

- (UIAlertView*)alert:(NSString *)msg;
- (UIAlertView*)alert:(NSString *)msg button:(NSString *)buttonTitle,...;
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(id)buttonTitle,...;


- (NSArray *)getInputCheckConfig;
- (BOOL)checkInput;
- (BOOL)checkInput:(NSArray *)config;


+ (void)showNetConnectMessage;


@end
