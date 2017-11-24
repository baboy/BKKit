//
//  BHttpRequestManager.h
//  BCommon
//
//  Created by baboy on 4/1/15.
//  Copyright (c) 2015 baboy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BHttpRequestCacheHandler.h"

NS_ASSUME_NONNULL_BEGIN
@interface BHttpRequestManager :AFHTTPSessionManager /*: AFHTTPRequestOperationManager*/
@property (nonatomic, strong) NSArray *cacheRequestIgnoreParams;

+ (_Nonnull id)defaultManager;

- (nullable id )getJson:(nullable NSString *)URLString
                       parameters:(nullable id)parameters
                      cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                          success:(nullable void (^)(id _Nonnull task, id _Nullable json))success
                          failure:(nullable void (^)(id _Nullable task,id _Nullable json, NSError * _Nonnull error))failure;
- (nullable id)getJson:(nullable NSString *)URLString
                       parameters:(nullable id)parameters
                          success:(nullable void (^)(id _Nonnull task, id _Nullable json))success
                          failure:(nullable void (^)(id _Nullable task,id _Nullable json, NSError * _Nonnull error))failure;


- (nullable id )getData:(nullable NSString *)URLString
             parameters:(nullable id)parameters
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                success:(nullable void (^)(id _Nonnull task, id _Nullable json))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable json, NSError * _Nonnull error))failure;

- (nullable id)download:(NSString *_Nullable)URLString
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
            userInfo:(id _Nullable)userInfo
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nonnull task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure;

- (nullable id)download:(NSString *_Nullable)URLString
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nonnull task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure;

- (nullable id)download:(NSString *_Nullable)URLString
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nonnull task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure;


@end
NS_ASSUME_NONNULL_END
