//
//  Device.m
//  Pods
//
//  Created by baboy on 4/22/15.
//
//
#import <UIKit/UIKit.h>
#import "Device.h"
#import "Global.h"
#import "DBCache.h"

@implementation Device
- (void)setDeviceToken:(NSString *)deviceToken{
    [DBCache setValue:deviceToken forKey:@"device_token"];
}
- (NSString *)deviceToken{
    return [DBCache valueForKey:@"device_token"];
}
+ (instancetype)currentDevice{
    Device *device = [[Device alloc] init];
    device.appid =[ DBCache valueForKey:@"appid"];
    device.build = [DBCache valueForKey:@"build"];
    device.channel = [DBCache valueForKey:@"channel"];
    device.productId = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"];
    device.version = ([[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]?[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]);
    device.deviceId = [OpenUDID value];
    device.resolution = [NSString stringWithFormat:@"%dx%d", (int)[[UIScreen mainScreen] bounds].size.width, (int)[[UIScreen mainScreen] bounds].size.height];
    device.deviceName = [[UIDevice currentDevice] name];
    device.os = [[UIDevice currentDevice] systemName];
    device.osVersion = [[UIDevice currentDevice] systemVersion];
    device.platform = [[UIDevice currentDevice] model];
    return device;
}
@end
