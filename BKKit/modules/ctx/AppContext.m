//
//  Conf.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AppContext.h"
#import "BKKitDefines.h"
#import "DBCache.h"
#import "Utils.h"
#import "NSString+x.h"
#import "BApi.h"
#import "GString.h"
#import "Theme.h"
#import "Global.h"

@implementation AppContext

+ (BOOL) setNs:(NSString *)ns{
    return [DBCache setValue:ns forKey:@"app_namespace"];
}
+ (NSString *)ns{
    return [DBCache valueForKey:@"app_namespace"];
}
+ (void) setDeviceToken:(NSString *)deviceToken{
    [DBCache setValue:deviceToken forKey:@"device_token"];
}
+ (NSString *) deviceToken{
    return [DBCache valueForKey:@"device_token"];
}

+ (void)setConf:(NSString *)conf{
    [G setup:conf];
    [BApi setup:conf];
    [Theme setup:conf];
    [GString setup:conf];
}
@end





void add_app_start_times(){
    [DBCache setValue:[NSNumber numberWithInt:get_app_start_times()+1] forKey:@"app_start_times"];
    add_current_app_start_times();
}
int get_app_start_times(){
    return [DBCache intForKey:@"app_start_times"];
}
void add_current_app_start_times(){
    NSString *k = [NSString stringWithFormat:@"app_start_times_ver%@",BundleVersion];
    [DBCache setValue:[NSNumber numberWithInt:get_current_app_start_times()+1] forKey:k];
}
int get_current_app_start_times(){
    NSString *k = [NSString stringWithFormat:@"app_start_times_ver%@",BundleVersion];
    return [DBCache intForKey:k];
}
void set_current_app_comment(int level){
    NSString *k = [NSString stringWithFormat:@"current_app_comment_ver%@",BundleVersion];
    [DBCache setValue:[NSNumber numberWithInt:level] forKey:k];
}
int get_current_app_comment(){
    NSString *k = [NSString stringWithFormat:@"current_app_comment_ver%@",BundleVersion];
    return [DBCache intForKey:k];
}
