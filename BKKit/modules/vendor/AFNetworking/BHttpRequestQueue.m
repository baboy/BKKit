//
//  BHttpRequestQueue.m
//  Pods
//
//  Created by baboy on 1/18/16.
//
//

#import "BHttpRequestQueue.h"
#import "NSString+x.h"
#import "Global.h"

@implementation BHttpRequestTask
- (id _Nonnull)initWithTask:(NSURLSessionTask *_Nullable)task UUID:(NSUUID *_Nullable)uuid  identifier:(NSString *_Nullable)identifier{
    if (self = [super init]) {
        self.task = task;
        self.uuid = uuid;
        self.identifier = identifier;
    }
    return self;
}
- (void)cancel{
    if (self.delegate) {
        [self.delegate cancelTask:self];
    }else{
        [self.task cancel];
    }
}
@end
@interface BHttpRequestQueue()
@end
@implementation BHttpRequestQueue
- (id)init{
    if (self = [super init]) {
        self.queue = [NSMutableArray array];
        self.maxConcurrentTaskCount = 10;
    }
    return self;
}
//当前正在执行的程序数量
- (int)currentRunningTaskCount{
    @synchronized(self) {
        int n = 0;
        for (int i=0; i<self.queue.count; i++) {
            BHttpRequestRelativeTask *task = [self.queue objectAtIndex:i];
            if (task.task.state == NSURLSessionTaskStateRunning) {
                ++n;
            }
        }
        DLOG(@"%d",n);
        return n;
    }
}
- (BOOL)cancelTask:(BHttpRequestTask *)task{
    @synchronized(self) {
        BHttpRequestRelativeTask *relativeTask = [self taskForIdentifier:task.identifier];
        for (NSInteger i = 0; i < relativeTask.handlers.count; i++) {
            BHttpResponseHandler *handler = [relativeTask.handlers objectAtIndex:i];
            if ([handler.uuid isEqual:task.uuid]) {
                [relativeTask.handlers removeObject:handler];
                if (relativeTask.handlers.count == 0) {
                    [self removeTask:relativeTask];
                    break;
                }
            }
        }
        
    }
    [self startNext];
    return YES;
}
- (void)removeTask:(BHttpRequestRelativeTask *)relativeTask{
    @synchronized(self) {
        [relativeTask.handlers removeAllObjects];
        [self.queue removeObject:relativeTask];
    }
    [self startNext];
}
- (void)clearQueue{
    @synchronized(self) {
        for (NSInteger i=self.queue.count-1; i>=0; i++) {
            BHttpRequestRelativeTask *relativeTask = [self.queue objectAtIndex:i];
            if (relativeTask.task.state == NSURLSessionTaskStateCompleted || relativeTask.task.state == NSURLSessionTaskStateCanceling) {
                [self.queue removeObject:relativeTask];
                break;
            }
        }
    }
    [self startNext];
}
- (void)startNext{
    @synchronized(self) {
        if([self currentRunningTaskCount] < self.maxConcurrentTaskCount){
            for (int i=0; i<self.queue.count; i++) {
                BHttpRequestRelativeTask *relativeTask = [self.queue objectAtIndex:i];
                if (relativeTask.task.state == NSURLSessionTaskStateSuspended) {
                    [relativeTask.task resume];
                    break;
                }
            }
            
        }
    }
}

- (BHttpRequestRelativeTask *_Nullable)taskForIdentifier:(NSString *_Nonnull)identifier{
    for (int i=0; i<self.queue.count; i++) {
        BHttpRequestRelativeTask *relativeTask = [self.queue objectAtIndex:i];
        if ([relativeTask.identifier isEqualToString:identifier]) {
            return relativeTask;
        }
    }
    return nil;
}
- (void)addHandler:(BHttpResponseHandler *_Nullable)handler identifier:(NSString *_Nonnull)identifier{
    @synchronized(self) {
        BHttpRequestRelativeTask *relativeTask = [self taskForIdentifier:identifier];
        [relativeTask addHandler:handler];
    }
}
- (void)addTask:(BHttpRequestRelativeTask *)relativeTask{
    @synchronized(self) {
        [self.queue addObject:relativeTask];
    }
    [self startNext];
}
@end

@implementation  BHttpResponseHandler : NSObject
- (id)initWithUUID:(NSUUID *)uuid
           success:(nullable void (^)(id task, id data))success
           failure:(nullable void (^)(id task, id data, NSError* error))failure{
    if (self = [super init]) {
        self.uuid = uuid;
        self.successBlock = success;
        self.failureBlock = failure;
    }
    return self;
}
@end

@implementation  BHttpRequestRelativeTask
- (id)initWithIdentifier:(NSString *)identifier task:(NSURLSessionTask *)task{
    if (self = [super init]) {
        self.identifier = identifier;
        self.task = task;
        self.handlers = [NSMutableArray array];
    }
    return self;
}
- (void)addHandler:(BHttpResponseHandler*)handler{
    [self.handlers addObject:handler];
}
- (void)removeHandler:(BHttpResponseHandler*)handler{
    [self.handlers removeObject:handler];
}
@end