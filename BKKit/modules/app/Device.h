//
//  Device.h
//  Pods
//
//  Created by baboy on 4/22/15.
//
//

#import <Foundation/Foundation.h>
#import "Model.h"
@interface Device : Model
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *build;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceToken;

+ (instancetype)currentDevice;
@end
