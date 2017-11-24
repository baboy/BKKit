//
//  Application.m
//  iVideo
//
//  Created by tvie on 13-10-14.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "Application.h"
#import "BKKitDefines.h"
#import "Utils.h"
#import "BApi.h"
#import "Global.h"
#import "Group.h"
#import "Device.h"
#import "BHttpRequestManager.h"
#import "HttpResponse.h"
#import "App.h"

#define ApiQueryAppVersion      [BApi apiForKey:@"app_version"]
#define ApiRegisterDeviceToken  [BApi apiForKey:@"app_register"]
#define ApiPostFeedback         [BApi apiForKey:@"app_feedback"]
#define ApiQueryAppList         [BApi apiForKey:@"app_market"]

@implementation Application
- (void)dealloc{
    //[super dealloc];
    
    ////
    ////
    ////
    ////
    ////
    ////
    ////
    ////
}
- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.appContent = nullToNil([dic objectForKey:@"content"]);
        self.appDownloadUrl = nullToNil([dic objectForKey:@"download_url"]);
        self.appIcon = nullToNil([dic objectForKey:@"icon"]);
        self.appLink = nullToNil([dic objectForKey:@"link"]);
        if (!self.appLink) {
            self.appDownloadUrl = nullToNil([dic objectForKey:@"appStore"]);
        }
        self.appName = nullToNil([dic objectForKey:@"name"]);
        self.appScrore = nullToNil([dic objectForKey:@"score"]);
        self.version = nullToNil([[dic objectForKey:@"version"] description]);
        self.appSummary = nullToNil([dic objectForKey:@"summary"]);
    }
    return self;
}
+ (NSArray *)appsFromArray:(NSArray *)array{
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0, n = [array count]; i < n; i++) {
        Application *app = /*AUTORELEASE*/([[Application alloc] initWithDictionary:[array objectAtIndex:i]]);
        [list addObject:app];
    }
    return list;
}

#pragma mark -- 请求应用列表
+ (id)getAppListSuccess:(void (^)(id task,id data))success failure:(void (^)(id task,id data, NSError *error))failure{
    
    id param = [[Device currentDevice] dict];
    return [[BHttpRequestManager defaultManager] getJson:ApiQueryAppList
                                       parameters:param
                                      cachePolicy:BHttpRequestCachePolicyFallbackToCacheIfLoadFails
                                          success:^(id _Nonnull task, id _Nullable json) {
                                              NSError *error = nil;
                                              NSArray *groups = nil;
                                              
                                              HttpResponse *response = [HttpResponse responseWithDictionary:json];
                                              if ([response isSuccess]) {
                                                  groups = [Group groupsFromArray:[response data]];
                                                  for (Group *group in groups) {
                                                      group.data = [Application appsFromArray:group.data];
                                                  }
                                              }else{
                                                  error = response.error;
                                              }
                                              if (success) {
                                                  success(task,groups);
                                              }
                                          }
                                          failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
                                              if (failure) {
                                                  failure(task, nil, error);
                                              }
                                          }];
}


#pragma mark -- 获取关于
+ (id )getAppAboutCallback:(void(^)(id task,id response,NSError *error))callback{
    return [self getAppAboutWithOutput:@"json" callback:callback];
}

+ (id )getAppAboutWithOutput:(NSString *)output callback:(void(^)(id task,id response,NSError *error))callback{
    output = output ?:@"html";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[[Device currentDevice] dict]];
    [param setValue:output forKey:@"output"];
    return nil;
    /*
    return [[BHttpRequestManager defaultManager]
            dataRequestWithURLRequest:ApiQueryAbout
            parameters:param
            success:^(id task, id data, bool isReadFromCache) {
                id ret = nil;
                id error = nil;
                if ([output isEqualToString:@"json"]) {
                    id json = [data json];
                    if (json) {
                    HttpResponse *res = [HttpResponse responseWithDictionary:json];
                        if ([res isSuccess]) {
                            ret = [res data];
                        }else{
                            error = [res error];
                        }
                    }
                }else{
                    ret = data;
                }
                if (callback) {
                    callback(task, ret, error);
                }
            }
            failure:^(id task, NSError *error) {
                DLOG(@"fail:%@",error);
                if (callback) {
                    callback(task, nil, error);
                }
            }];
     */
}

+ (id )feedback:(NSString *)content success:(void (^)(id task,id response))success failure:(void (^)(id task, NSError *error))failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[[Device currentDevice] dict]];
    [param setValue:content forKey:@"content"];
    [param setValue:APPID forKey:@"appid"];
    return [[BHttpRequestManager defaultManager] POST:ApiPostFeedback
                                    parameters:param
                                      progress:nil
                                       success:success
                                       failure:failure];
}
@end

@implementation ApplicationVersion
#pragma mark -- 检测版本
+ (id )getAppVersionSuccess:(void(^)(id task, ApplicationVersion* app))success failure:(void(^)(id task, ApplicationVersion* app,NSError *error))failure{
    
    
    id param = [[Device currentDevice] dict];
    return [[BHttpRequestManager defaultManager]
     getJson:ApiQueryAppVersion
     parameters:param
     success:^(id  _Nonnull task, id  _Nullable json) {
         DLOG(@"json = %@",json);
         NSError *error = nil;
         ApplicationVersion *app = nil;
         HttpResponse *respone = [HttpResponse responseWithDictionary:json];
         if ([respone isSuccess]) {
             app = [[ApplicationVersion alloc] initWithDictionary:respone.data];
         }else {
             error = respone.error;
         }
         
         if (success) {
             success(task,app);
         }
     }
     failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
         failure(task,json,error);
     }];
}

+ (id )registerNotificationDeviceToken:(NSString *)token success:(void(^)(id task, NSDictionary *json))success failure:(void(^)(id task, NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[[Device currentDevice] dict]];
    [param setValue:token forKey:@"token"];
    return [[BHttpRequestManager defaultManager]
     POST:ApiRegisterDeviceToken
     parameters:param
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
         HttpResponse *respone = [HttpResponse responseWithDictionary:json];
         if (success) {
             success(task, [respone data]);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(task, error);
     }];
    }
@end
