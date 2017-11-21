//
//  BHttpRequestQueue.h
//  Pods
//
//  Created by baboy on 1/18/16.
//
//
#import <Foundation/Foundation.h>


@interface BHttpRequestTask: NSObject
@property (nonatomic, weak)  id _Nullable delegate;
@property (nonatomic, strong) NSURLSessionTask *_Nullable task;
@property (nonatomic, strong) NSUUID *_Nullable uuid;
@property (nonatomic, strong) NSString *_Nullable identifier;
- (id _Nonnull)initWithTask:(NSURLSessionTask *_Nullable)task UUID:(NSUUID *_Nullable)uuid identifier:(NSString *_Nullable)identifier;
- (void)cancel;
@end

@interface BHttpResponseHandler : NSObject
@property (nonatomic, strong) NSUUID *_Nonnull uuid;
@property (nonatomic, copy) void (^_Nullable successBlock )(id _Nullable task, id _Nullable data);
@property (nonatomic, copy) void (^_Nullable failureBlock)(id _Nullable task, id _Nullable data, NSError* _Nullable error);
- (id _Nonnull)initWithUUID:(NSUUID *_Nullable)uuid
           success:(nullable void (^)(id _Nullable task, id _Nullable data))success
           failure:(nullable void (^)(id _Nullable task, id _Nullable data, NSError* _Nullable error))failure;
@end
@interface BHttpRequestRelativeTask:NSObject
@property (nonatomic, strong) NSString * _Nullable identifier;
@property (nonatomic, strong) NSURLSessionTask * _Nullable task;
@property (nonatomic, strong) NSMutableArray * _Nullable handlers;
- (id _Nonnull)initWithIdentifier:(NSString *_Nullable)identifier task:(NSURLSessionTask *_Nullable)task;
- (void)addHandler:(BHttpResponseHandler*_Nullable)handler;
- (void)removeHandler:(BHttpResponseHandler*_Nullable)handler;
@end


@interface BHttpRequestQueue : NSObject
@property (nonatomic, strong) NSMutableArray *_Nonnull queue;
@property (nonatomic, strong) NSMutableDictionary *_Nonnull tasks;
@property (nonatomic, assign) int maxConcurrentTaskCount;
- (BOOL)cancelTask:(BHttpRequestTask *_Nullable)task;

- (BHttpRequestRelativeTask *_Nullable)taskForIdentifier:(NSString *_Nonnull)identifier;
- (void)addHandler:(BHttpResponseHandler *_Nullable)handler identifier:(NSString *_Nonnull)identifier;
- (void)addTask:(BHttpRequestRelativeTask *_Nullable)task;
- (void)removeTask:(BHttpRequestRelativeTask *_Nullable)task;
@end
