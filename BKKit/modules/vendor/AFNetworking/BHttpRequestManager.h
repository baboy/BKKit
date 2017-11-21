//
//  BHttpRequestManager.h
//  BCommon
//
//  Created by baboy on 4/1/15.
//  Copyright (c) 2015 baboy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BHttpRequestOperation.h"

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

/*
- (NSMutableURLRequest *)requestWithPOSTURL:(NSString *)url parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)requestWithGETURL:(NSString *)url parameters:(NSDictionary *)parameters;
- (BHttpRequestOperation *)createHttpRequestOperationWithRequest:(NSURLRequest *)request
                                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                                         success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                         failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// json request with get
- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     userInfo:(id)userInfo
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                  cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                      success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// json request with post
- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                      userInfo:(id)userInfo
                                                   cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                       success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                       failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;;

- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                    cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                                        success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                    parameters:(id)parameters
                                                       success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                       failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

// data request with get

- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;


// file request with get
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                         cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                             success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;

- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;
- (BHttpRequestOperation *)cacheFileRequestWithURLRequest:(NSString *)URLString
                                               parameters:(id)parameters
                                                 userInfo:(id)userInfo
                                                  success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                                  failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure;



- (BHttpRequestOperation *)downloadFileWithURLRequest:(NSString *)URLString
                                           parameters:(id)parameters
                                             userInfo:(id)userInfo
                                          cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                                              success:(void (^)(BHttpRequestOperation *operation, id data,bool isReadFromCache)) success
                                              failure:(void (^)(BHttpRequestOperation *operation, NSError *error)) failure
                                             progress:(void (^)(id operation,long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock;
 */
@end
NS_ASSUME_NONNULL_END
