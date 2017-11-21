//
//  Application.h
//  iVideo
//
//  Created by tvie on 13-10-14.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKKitHttp.h"
enum {
    AppUpdateRoleNormal,
    AppUpdateRoleMsg=9,
    AppUpdateRolePrompt,
    AppUpdateRoleUpdate,
    AppUpdateRoleForbidden
};
typedef NSInteger AppUpdateRole;

@interface Application : Model

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *appSummary;
@property (nonatomic, retain) NSString *appContent;
@property (nonatomic, retain) NSString *appScrore;
@property (nonatomic, retain) NSString *appLink;
@property (nonatomic, retain) NSString *appDownloadUrl;
@property (nonatomic, retain) NSString *appIcon;
@property (nonatomic, retain) NSString *version;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (NSArray *)appsFromArray:(NSArray *)array;

#pragma mark -- 请求应用列表
+ (id)getAppListSuccess:(void (^)(id task,id data))success failure:(void (^)(id task,id data, NSError *error))failure;

#pragma mark -- 获取关于
+ (id )getAppAboutCallback:(void(^)(id task,id response,NSError *error))callback;
+ (id )getAppAboutWithOutput:(NSString *)output callback:(void(^)(id task,id response,NSError *error))callback;

+ (id )feedback:(NSString *)content success:(void (^)(id task,id response))success failure:(void (^)(id task, NSError *error))failure ;
@end

@interface ApplicationVersion : Model
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *appStore;
@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *build;
//检测版本更新
+ (id )getAppVersionSuccess:(void(^)(id task, ApplicationVersion* app))success failure:(void(^)(id task, ApplicationVersion* app,NSError *error))failure;

+ (id )registerNotificationDeviceToken:(NSString *)token success:(void(^)(id task, NSDictionary *json))success failure:(void(^)(id task, NSError *error))failure;


@end
