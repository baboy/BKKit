//
//  CacheURLProtocol.m
//  iLook
//
//  Created by Yinghui Zhang on 2/26/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "CacheURLProtocol.h"
#import "Base64.h"
#import "BKKitDefines.h"
#import "NSString+x.h"
#import "BHttpRequestCacheHandler.h"
#import "BHttpRequestManager.h"

@interface CacheURLProtocol()
@property(nonatomic, retain) id task;
@end

@implementation CacheURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    DLOG(@"%@",request);
    if ([request respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
        [(NSMutableURLRequest*)request setValue:@"Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10" forHTTPHeaderField:@"User-Agent"];
    }
    NSString *scheme = [[request URL] scheme];
    return ([scheme isEqualToString:CacheSchemeName]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

// Called when URL loading system initiates a request using this protocol. Initialise input stream, buffers and decryption engine.
- (void)startLoading{    
    NSURL *cacheURL = [self.request URL];
    NSString *urlString = [cacheURL httpURLString];
    NSURL *reqURL = [NSURL URLWithString:urlString];
    
    BHttpRequestCacheHandler *cache = [BHttpRequestCacheHandler fileCacheHandler];
    NSData *data = [cache cacheDataForURL:reqURL];
    if (data) {
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    id task = [[BHttpRequestManager defaultManager]
     download:urlString
     progress:nil
    success:^(id  _Nonnull task, NSURL *_Nullable fp) {
        NSData *data = nil;
        if ([[fp path] fileExists]) {
            data = [NSData dataWithContentsOfFile:fp];
        }
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
               failure:^(id  _Nullable task, NSURL *_Nullable fp, NSError * _Nonnull error) {
                   if (fp) {
                       
                       NSData *data = nil;
                       if ([[fp path] fileExists]) {
                           data = [NSData dataWithContentsOfFile:fp];
                       }
                       [self.client URLProtocol:self didLoadData:data];
                       [self.client URLProtocolDidFinishLoading:self];
                   }else{
                       [self.client URLProtocol:self didFailWithError:error];
                   }
               }];
    self.task = task;
}

// Called by URL loading system in response to normal finish, error or abort. Cleans up in each case.
- (void)stopLoading{
    //DLOG(@"stopLoading...:%d",[[cacheRequest responseData] length]);
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}
- (void)dealloc{  
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}
@end


@implementation NSURL(cache)

+ (NSString*) URLStringWithScheme:(NSString *)scheme urlString:(NSString*)urlString{    
    NSString *base64 = [Base64 stringByWebSafeEncodeString:urlString];
    NSString *url = [NSString stringWithFormat:@"%@://%@",scheme,base64];
    return url;
}
+ (NSString *) cacheImageURLString:(NSString *)urlString{    
    return [self URLStringWithScheme:CacheSchemeName urlString:urlString];

}
+ (NSURL*) cacheImageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[self cacheImageURLString:urlString]];
}

+ (NSURL *) imageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[NSURL URLStringWithScheme:ImageScheme urlString:urlString]];
}
+ (NSURL *) videoURLWithString:(NSString *)urlString{    
    return [NSURL URLWithString:[NSURL URLStringWithScheme:VideoScheme urlString:urlString]];
}
+ (BOOL) isCacheImageURL:(NSURL *)url{
    if (url && [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",CacheSchemeName]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isImageURL{
    return  [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",ImageScheme]];
}
- (BOOL) isVideoURL{    
    return [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",VideoScheme]];
}
- (NSString *)httpURLString{
    NSString *urlString = [Base64 stringByWebSafeDecodeString:[self host]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return urlString;
}
+ (NSString *)imageScheme{
    return ImageScheme;
}
+ (NSString *)videoScheme{
    return VideoScheme;
}
@end

