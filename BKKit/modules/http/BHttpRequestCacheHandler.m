//
//  BHttpRequestCache.m
//  iLookForiPad
//
//  Created by baboy on 13-2-28.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpRequestCacheHandler.h"
#import "BKKitDefines.h"
#import "Utils.h"
#import "NSString+x.h"
#import "App.h"

NSString * getCacheFilePath(NSURL *url) {
    NSString *fn = [[url absoluteString] md5];
    NSString *ext = [url pathExtension];
    if ([ext length]==0) {
        ext = @"tmp";
    }
    return [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",fn,ext]];
}
NSData * getCacheFileData(NSURL *url){
    NSString *fp = getCacheFilePath(url);
    if (fp && [[NSFileManager defaultManager] fileExistsAtPath:fp]) {
        return [NSData dataWithContentsOfFile:fp];
    }
    return nil;
}

@implementation BHttpRequestCacheHandler
+ (id)defaultCacheHandler{
    static id _defaultHttpRequestCache = nil;
    static dispatch_once_t initOnceDefaultCache;
    dispatch_once(&initOnceDefaultCache, ^{
        _defaultHttpRequestCache = [[BHttpRequestCacheHandler alloc] init];
        [(BHttpRequestCacheHandler*)_defaultHttpRequestCache setCachePolicy:BHttpRequestCachePolicyFallbackToCacheIfLoadFails];
    });    
    return _defaultHttpRequestCache;
}
+ (id)fileCacheHandler{
    static id _fileRequestCache = nil;
    static dispatch_once_t initOnceFileCache;
    dispatch_once(&initOnceFileCache, ^{
        _fileRequestCache = [[BHttpRequestCacheHandler alloc] init];
        [(BHttpRequestCacheHandler*)_fileRequestCache setCachePolicy:BHttpRequestCachePolicyLoadIfNotCached];
    });
    return _fileRequestCache;
}

+ (id)handlerWithCachePolicy:(BHttpRequestCachePolicy) cachePolicy{
    BHttpRequestCacheHandler *cacheHandler = [[BHttpRequestCacheHandler alloc] init];
    [cacheHandler setCachePolicy:cachePolicy];
    return cacheHandler;
}
- (NSString *)cachePathForURL:(NSURL *)url{
    return [BHttpRequestCacheHandler cachePathForURL:url];
}
- (NSData *)cacheDataForURL:(NSURL *)url{
    return [BHttpRequestCacheHandler cacheDataForURL:url];
}
+ (NSString *)cachePathForURL:(NSURL *)url{
    NSString *fn = [[url absoluteString] md5];
    NSString *ext = [url pathExtension];
    return [AppCache cachePath:[NSString stringWithFormat:@"%@.%@",fn,ext]];
}
+ (NSData *)cacheDataForURL:(NSURL *)url{
    NSString *fp = [self cachePathForURL:url];
    if (fp && [[NSFileManager defaultManager] fileExistsAtPath:fp]) {
        return [NSData dataWithContentsOfFile:fp];
    }
    return nil;
}
@end
 
