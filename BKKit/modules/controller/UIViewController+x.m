//
//  UIViewController+x.m
//  Pods
//
//  Created by baboy on 1/27/16.
//
//

#import "UIViewController+x.h"
#import "NSString+x.h"
#import "BIndicator.h"
#import "NetChecker.h"
#import "GString.h"

BOOL checkInput(NSArray *config,id delegate){
    NSArray* confs = config;
    for (NSDictionary *conf in confs) {
        UITextField *field = [conf valueForKey:@"field"];
        NSString *name = [conf valueForKey:@"name"];
        int minLen = [[conf valueForKey:@"min-len"] intValue];
        int maxLen = [[conf valueForKey:@"max-len"] intValue];
        NSString *regex = [conf valueForKey:@"regex"];
        NSString *regex_desc = [conf valueForKey:@"regex-desc"];
        NSString *val = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *errMsg = nil;
        if (regex && ![val testRegex:regex]) {
            errMsg = [NSString stringWithFormat:@"%@格式错误", name];
            if (regex_desc) {
                errMsg = [NSString stringWithFormat:@"%@,%@",errMsg, regex_desc];
            }
        }else if ([val length] == 0) {
            errMsg = [NSString stringWithFormat:@"%@不能为空",name];
        }else if ([val length] < minLen) {
            errMsg = [NSString stringWithFormat:@"%@长度不能小于%d位",name,minLen];
        }else if ( maxLen > 0 && [val length]>maxLen ){
            errMsg = [NSString stringWithFormat:@"%@长度不能大于%d位",name,maxLen];
        }
        if (errMsg) {
            [delegate alert:errMsg];
            [field becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}
@implementation UIViewController(x)
- (NSArray *)getInputCheckConfig{
    return nil;
}
- (BOOL)checkInput{
    return [self checkInput:[self getInputCheckConfig]];
}
- (BOOL)checkInput:(NSArray *)config{
    return NO;
    
}

- (UIAlertView*)alert:(NSString *)msg button:(NSString *)buttonTitle,...{
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:2];
    va_list args;
    va_start(args, buttonTitle);
    id arg;
    if (buttonTitle) {
        [buttons addObject:buttonTitle];
        while ( (arg = va_arg(args, NSString*) ) != nil) {
            [buttons addObject:arg];
        }
    }
    va_end(args);
    return [self alertWithTitle:nil message:msg button:buttons,nil];
}
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(id)buttonTitle,...{
    if (!msg) {
        return nil;
    }
    NSMutableArray *buttons = nil;
    if ([buttonTitle isKindOfClass:[NSArray class]]) {
        buttons = buttonTitle;
    }else{
        buttons = [NSMutableArray arrayWithCapacity:2];
        va_list args;
        va_start(args, buttonTitle);
        id arg;
        if (buttonTitle) {
            [buttons addObject:buttonTitle];
            while ( (arg = va_arg(args, NSString*) ) != nil) {
                [buttons addObject:arg];
            }
        }
        va_end(args);
    }
    if ([buttons count] == 0) {
        buttons = [NSMutableArray arrayWithObject:NSLocalizedString(@"确定", @"alert")];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil)
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    NSInteger n = [buttons count];
    for (int i=0; i<n; i++) {
        [alert addButtonWithTitle:[buttons objectAtIndex:i]];
    }
    [alert show];
    return alert;
}
- (UIAlertView*)alert:(NSString *)msg{
    UIAlertView *alert = [self alert:msg button:NSLocalizedString(@"确定", @"alert")];
    [alert setTag:AlertViewTagAlert];
    [alert show];
    return alert;
}

+ (void)showNetConnectMessage{
    NSString *msg = NoAvailableConnection;
    if ([NetChecker isAvailable]) {
        msg = [NSString stringWithFormat:NSLocalizedString(@"你使用的是%@网络!", nil),
               ([NetChecker isConnectWifi] ? @"WIFI" : @"2G/3G/4G")];
    }
    [BIndicator showMessage:msg duration:2.0f];
}
@end
