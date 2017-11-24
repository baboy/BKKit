//
//  BHttpRequestManager.m
//  BCommon
//
//  Created by baboy on 4/1/15.
//  Copyright (c) 2015 baboy. All rights reserved.
//

#import "BHttpRequestManager.h"
#import "BHttpRequestQueue.h"
#import "NSURLSessionTask+x.h"
#import "BKKitDefines.h"
#import "Utils.h"
#import "RegexKitLite.h"
#import "NSString+x.h"
#import "NSDictionary+x.h"
#import "NSArray+x.h"
#import "NSData+x.h"

@interface BHttpRequestManager()
@property (nonatomic, strong) BHttpRequestQueue *requestQueue;
@end

@implementation BHttpRequestManager
+ (id)defaultManager {
    static id _defaultHttpRequestManager = nil;
    static dispatch_once_t initOnceHttpRequestManager;
    dispatch_once(&initOnceHttpRequestManager, ^{
        _defaultHttpRequestManager = [[BHttpRequestManager alloc] init];
    });
    
    return _defaultHttpRequestManager;
}
- (id)init{
    if (self = [super init]) {
        self.responseSerializer.acceptableContentTypes = nil;
        self.requestQueue = [[BHttpRequestQueue alloc] init];
    }
    return self;
}

- (BOOL)cancelTask:(BHttpRequestTask *_Nullable)task{
    [self.requestQueue cancelTask:task];
    return YES;
}
- (void)setCacheRequestIgnoreParams:(NSArray *)cacheRequestIgnoreParams{
    _cacheRequestIgnoreParams = cacheRequestIgnoreParams;
}
- (NSString *)getRequestCachePath:(NSString *)url{
    NSString *u = url;
    for (NSString *field in self.cacheRequestIgnoreParams) {
        NSString *f = [field stringByReplacingOccurrencesOfRegex:@"\\*" withString:@"[0-9a-zA-Z_-]+"];
        NSString *re = [NSString stringWithFormat:@"(%@=[^=&]{0,}&?)",f];
        NSArray *arr = [u arrayOfCaptureComponentsMatchedByRegex:re];
        u = [u stringByReplacingOccurrencesOfRegex:re withString:@""];
    }
    NSString *fp = getCacheFilePath([NSURL URLWithString:u]);
    return fp;
}
- (nullable id )getData:(nullable NSString *)URLString
             parameters:(nullable id)parameters
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                success:(nullable void (^)(id _Nonnull task, id _Nullable json))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable json, NSError * _Nonnull error))failure;{
    //NSURLSessionDataTask
    NSURLSessionTask *task = [super GET:URLString
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nullable dataTask, id _Nonnull json){
                  success(dataTask,json);
                  if (cachePolicy & BHttpRequestCachePolicyCached) {
                      if (json) {
                          
                          NSString *fp = getCacheFilePath([NSURL URLWithString:[URLString URLStringWithParam:parameters]]);
                          [[json jsonData] writeToFile:fp atomically:YES];
                          DLOG(@"%@%lld",fp,[fp sizeOfFile]);
                      }
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error){
                  id json = nil;
                  if (cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails) {
                      NSData *data = getCacheFileData([NSURL URLWithString:[URLString URLStringWithParam:parameters]]);
                      if (data) {
                          DLOG(@"read cache:%@",getCacheFilePath([NSURL URLWithString:[URLString URLStringWithParam:parameters]]));
                          json = [data json];
                      }
                  }
                  failure(dataTask,json,error);
              }];
    return task;

}
- (id)getJson:(NSString *)URLString
                   parameters:(id)parameters
                   cachePolicy:(BHttpRequestCachePolicy)cachePolicy
                      success:(void (^)(id _Nonnull, id _Nullable))success
                      failure:(void (^)(id _Nullable,id _Nullable, NSError * _Nonnull))failure
{
    __block BHttpRequestTask *task = nil;
    @synchronized(self.requestQueue) {
        
        NSString *url = [URLString URLStringWithParam:parameters];
        NSString *identifier = url;
        NSUUID *uuid = [NSUUID UUID];
        BHttpResponseHandler *handler = [[BHttpResponseHandler alloc] initWithUUID:uuid
                                                                           success:success
                                                                           failure:failure];
        BHttpRequestRelativeTask *relativeTask = [self.requestQueue taskForIdentifier:identifier];
        if (relativeTask) {
            [relativeTask addHandler:handler];
            task = [[BHttpRequestTask alloc] initWithTask:relativeTask.task
                                                                       UUID:uuid
                                                                 identifier:identifier];
            task.delegate = self;
            return task;
        }
        NSURLSessionTask *sessionTask = nil;
        sessionTask = [super GET:url
                      parameters:nil
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nullable dataTask, id _Nonnull json){
                             //success(dataTask,json);
                             @synchronized(self.requestQueue) {
                                 BHttpRequestRelativeTask *relativeTask = [self.requestQueue taskForIdentifier:identifier];
                                 for (BHttpResponseHandler *handler in relativeTask.handlers) {
                                     handler.successBlock(dataTask,json);
                                 }
                                 [self.requestQueue removeTask:relativeTask];
                             }
                             
                             
                             if (cachePolicy & BHttpRequestCachePolicyCached) {
                                 if (json) {
                                     NSString *fp = [self getRequestCachePath:url];
                                     [[json jsonData] writeToFile:fp atomically:YES];
                                     //DLOG(@"%@%lld",fp,[fp sizeOfFile]);
                                 }
                             }
                             
                         }
                         failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error){
                             id json = nil;
                             if (cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails) {
                                 NSString *fp = [self getRequestCachePath:url];
                                 NSData *data = [fp fileData];
                                 if (data) {
                                     DLOG(@"read cache:%@",getCacheFilePath([NSURL URLWithString:[URLString URLStringWithParam:parameters]]));
                                     json = [data json];
                                 }
                             }
                             @synchronized(self.requestQueue) {
                                 BHttpRequestRelativeTask *relativeTask = [self.requestQueue taskForIdentifier:identifier];
                                 for (BHttpResponseHandler *handler in relativeTask.handlers) {
                                     handler.failureBlock(dataTask,json,error);
                                 }
                                 [self.requestQueue removeTask:relativeTask];
                             }
                             //failure(dataTask,json,error);
                         }];
        DLOG(@"request:%@",[url md5]);
        relativeTask = [[BHttpRequestRelativeTask alloc] initWithIdentifier:identifier task:sessionTask];
        [relativeTask addHandler:handler];
        task = [[BHttpRequestTask alloc] initWithTask:sessionTask
                                                 UUID:uuid
                                           identifier:identifier];
        task.delegate = self;
        [self.requestQueue addTask:relativeTask];
    }
    return task;
}
- (id)getJson:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(id _Nonnull, id _Nullable))success
                          failure:(void (^)(id _Nullable,id _Nullable, NSError * _Nonnull))failure
{
    return [self getJson:URLString
              parameters:parameters
            cachePolicy:BHttpRequestCachePolicyNone
                 success:success
                 failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    return [super POST:URLString
            parameters:parameters
              progress:nil
               success:success
               failure:failure];
}
- (nullable id)download:(NSString *_Nullable)URLString
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
               userInfo:(id _Nullable)userInfo
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nullable task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure{
    
    __block BHttpRequestTask *task = nil;
    @synchronized(self.requestQueue) {
        if (cachePolicy & BHttpRequestCachePolicyLoadIfNotCached) {
            NSString *fp = getCacheFilePath([NSURL URLWithString:URLString]);
            if ([fp sizeOfFile]>0) {
                success(nil,[NSURL fileURLWithPath:fp]);
                DLOG(@"download,read from cache:%lld,%@",[fp sizeOfFile],[fp lastPathComponent]);
                return nil;
            }
        }
        
        NSString *url = URLString;
        NSString *identifier = url;
        NSUUID *uuid = [NSUUID UUID];
        BHttpResponseHandler *handler = [[BHttpResponseHandler alloc] initWithUUID:uuid
                                                                           success:success
                                                                           failure:failure];
        BHttpRequestRelativeTask *relativeTask = [self.requestQueue taskForIdentifier:identifier];
        if (relativeTask) {
            [relativeTask addHandler:handler];
            task = [[BHttpRequestTask alloc] initWithTask:relativeTask.task
                                                     UUID:uuid
                                               identifier:identifier];
            task.delegate = self;
            return task;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        NSURLSessionDownloadTask *sessionTask = [super downloadTaskWithRequest:request
                                                                       progress:downloadProgressBlock
                                                                    destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                        return [NSURL fileURLWithPath:getCacheFilePath([NSURL URLWithString:URLString])];
                                                                    }
                                                              completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                  @synchronized(self.requestQueue) {
                                                                      BHttpRequestRelativeTask *relativeTask = [self.requestQueue taskForIdentifier:identifier];
                                                                      for (BHttpResponseHandler *handler in relativeTask.handlers) {
                                                                          if (error) {
                                                                              handler.failureBlock(nil,filePath,error);
                                                                          }else{
                                                                              handler.successBlock(nil,filePath);
                                                                          }
                                                                      }
                                                                      [self.requestQueue removeTask:relativeTask];
                                                                  }
                                                                  
                                                              }];
        DLOG(@"download url:%@",url);
        relativeTask = [[BHttpRequestRelativeTask alloc] initWithIdentifier:identifier task:sessionTask];
        [relativeTask addHandler:handler];
        task = [[BHttpRequestTask alloc] initWithTask:sessionTask
                                                 UUID:uuid
                                           identifier:identifier];
        task.delegate = self;
        [self.requestQueue addTask:relativeTask];
    }
    
    return task;

}
- (nullable id)download:(NSString *_Nullable)URLString
            cachePolicy:(BHttpRequestCachePolicy)cachePolicy
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nonnull task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure{
    return [self download:URLString
              cachePolicy:cachePolicy
                 userInfo:nil
                 progress:downloadProgressBlock
        success:success
                  failure:failure];
}

- (nullable id)download:(NSString *_Nullable)URLString
               progress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock
                success:(nullable void (^)(id _Nonnull task, id _Nullable fp))success
                failure:(nullable void (^)(id _Nullable task,id _Nullable fp, NSError * _Nonnull error))failure{
    return [self download:URLString
              cachePolicy:BHttpRequestCachePolicyLoadIfNotCached
                 progress:downloadProgressBlock
        success:success
                  failure:failure];
}
@end
