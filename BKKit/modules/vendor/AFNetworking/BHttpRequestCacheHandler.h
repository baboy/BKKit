//
//  BHttpRequestCache.h
//  iLookForiPad
//
//  Created by baboy on 13-2-28.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef _BHttpRequestCacheHandler_
    #define _BHttpRequestCacheHandler_

typedef enum _BHttpRequestCachePolicy {
    
    // no cache
	BHttpRequestCachePolicyNone = 0,
	// The the request write to the cache
	BHttpRequestCachePolicyCached = 1,
    // load if not cached
    BHttpRequestCachePolicyLoadIfNotCached = 1<<1 | BHttpRequestCachePolicyCached,
    //read cache if load failed
	BHttpRequestCachePolicyFallbackToCacheIfLoadFails = 1<<2 | BHttpRequestCachePolicyCached,
}BHttpRequestCachePolicy;



extern NSString * getCacheFilePath(NSURL *url) ;
extern NSData * getCacheFileData(NSURL *url);

@interface BHttpRequestCacheHandler : NSObject
@property (nonatomic, assign) BHttpRequestCachePolicy cachePolicy;
+ (id)defaultCacheHandler;
+ (id)fileCacheHandler;
+ (id)handlerWithCachePolicy:(BHttpRequestCachePolicy) cachePolicy;
- (NSString *)cachePathForURL:(NSURL *)url;
- (NSData *)cacheDataForURL:(NSURL *)url;
+ (NSString *)cachePathForURL:(NSURL *)url;
+ (NSData *)cacheDataForURL:(NSURL *)url;
@end

#endif
