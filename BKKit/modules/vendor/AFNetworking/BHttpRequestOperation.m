//
//  BHttpRequestOperation.m
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpRequestOperation.h"
#import "BKKitCategory.h"
#import "Global.h"


typedef void (^AFURLConnectionOperationProgressBlock)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);
/*
@interface AFURLConnectionOperation(x)<NSURLConnectionDataDelegate>
- (long long)totalBytesRead;
- (void)setTotalBytesRead:(long long)t;
- (AFURLConnectionOperationProgressBlock)downloadProgress;
- (NSRecursiveLock *)lock;
- (void)finish;
- (void)operationDidStart;
@end
*/


@interface BHttpRequestOperation()
/*
@property (readwrite, nonatomic, copy) void (^successCallbackBlock)(AFHTTPRequestOperation *operation, id responseObject);
@property (nonatomic, retain) NSString *tmpFilePath;
@property (nonatomic, assign) BOOL readFromCache;
 */
@end

@implementation BHttpRequestOperation
/*
- (void)dealloc{
}
- (NSString *)responseString{
    NSString *s = [super responseString];
    if (!s && [self responseData]) {
        s = ([[NSString alloc] initWithData:[self responseData] encoding:NSUTF8StringEncoding]);
    }
    return s;
}
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest{
    return YES;
}
- (void)setTmpFilePath:(NSString *)tmpFilePath{
    _tmpFilePath = tmpFilePath;
    if (!self.downloadResume)
        [tmpFilePath deleteFile];
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:tmpFilePath append:YES];
}

- (void)setCacheFilePath:(NSString *)cacheFilePath{
    _cacheFilePath = cacheFilePath ;
    NSString *tmpFilePath = tmpFilePath = [cacheFilePath stringByAppendingPathExtension:@"download"];
    if (!self.downloadResume) {
        [[NSString stringWithFormat:@"%@.%d",cacheFilePath,(int)arc4random()] stringByAppendingPathExtension:@"download"];
    }
    [self setTmpFilePath:tmpFilePath];
}
- (BHttpRequestCacheHandler *)cacheHandler{
    if (!_cacheHandler) {
        _cacheHandler = [[BHttpRequestCacheHandler alloc] init];
    }
    return _cacheHandler;
}
- (NSData *)responseData{
    NSData *data = [super responseData];
    if (!data && [self.cacheFilePath sizeOfFile] > 0) {
        data = [NSData dataWithContentsOfFile:self.cacheFilePath];
        if (!data && [self.tmpFilePath fileExists]) {
            data = [NSData dataWithContentsOfFile:self.tmpFilePath];
        }
    }
    return data;
}
- (void)operationDidStart{
    [self.lock lock];
    self.readFromCache = NO;
    // 准备缓存路径
    if ( (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyLoadIfNotCached)
        || (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails)
        || (self.cacheHandler.cachePolicy & BHttpRequestCachePolicySaveCache)
        || (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyDontLoad)) {
        NSString *cacheFilePath = [self.cacheHandler cachePathForURL:self.request.URL];
        [self setCacheFilePath:cacheFilePath];
    }
    //优先使用缓存
    if ( (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyLoadIfNotCached)
        || (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyDontLoad)) {
        if ([self.cacheFilePath sizeOfFile]>0) {
            
            self.readFromCache = YES;
            if (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyAlwaysLoad) {
                self.successCallbackBlock(self,[[self responseData] json]);
            }else{
                [self finish];
                [self.lock unlock];
                return;
            }
        };
    }
    long long downloadSize = [self.tmpFilePath sizeOfFile];
    if (self.downloadResume) {
        [(NSMutableURLRequest *)self.request setValue:[NSString stringWithFormat:@"bytes=%lld-", downloadSize] forHTTPHeaderField:@"Range"];
    }
    [self.lock unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalBytesRead += downloadSize;
        
        if (self.downloadProgress) {
            self.downloadProgress(0, self.totalBytesRead, self.response.expectedContentLength);
        }
    });
    self.readFromCache = NO;
    [super operationDidStart];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.receiveDataBlock) {
        self.receiveDataBlock(self,data);
    }
    [super connection:connection didReceiveData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.outputStream close];
    if (self.cacheFilePath) {
        DLOG(@"renameto");
        [self.cacheFilePath deleteFile];
        BOOL flag = [self.tmpFilePath renameFileTo:self.cacheFilePath];
        if (![self.cacheFilePath fileExists]) {
            DLOG(@"cache file:%d", flag);
        }
    }
    [super connectionDidFinishLoading:connection];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (self.cacheHandler.cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails) {
        if ([self.cacheFilePath sizeOfFile]>0) {
            self.readFromCache = YES;
        }
    }
    [super connection:connection didFailWithError:error];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    self.successCallbackBlock = success;
    [super setCompletionBlockWithSuccess:success failure:failure];
}
 */
@end
