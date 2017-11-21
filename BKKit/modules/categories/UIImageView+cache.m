//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//


#import "UIImageView+cache.h"
#import <objc/runtime.h>
#import "BKKitHttp.h"
#import "BKKitCategory.h"

static char UIImageViewCacheRequestTaskObjectKey;

@implementation UIImageView(cache)
- (void)dealloc{
    [self cancelRequest];
}
+ (id)imageDownloadManager {
    static id _imageDownloadManager = nil;
    static dispatch_once_t initOnceImageDownloadManager;
    dispatch_once(&initOnceImageDownloadManager, ^{
        _imageDownloadManager = [[BHttpRequestManager alloc] init];
    });
    return _imageDownloadManager;
}
- (id)requestTask {
    return objc_getAssociatedObject(self, &UIImageViewCacheRequestTaskObjectKey);
}

- (void)setRequestTask:(id)requestTask{
    objc_setAssociatedObject(self, &UIImageViewCacheRequestTaskObjectKey, requestTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)cancelRequest {
    [[self requestTask] cancel];
    [self setRequestTask:nil];
}
- (id)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback{
    [self cancelRequest];
    
    NSString *fp = nil;
    if ([url isURL]) {
        fp = [UIImageView cachePathForURLString:url];;
    }else{
        fp = url;
    }
    if ([fp fileExists]) {
        UIImage *img = [UIImage imageWithContentsOfFile:fp];
        if (img) {
            self.image = img;
            if (callback) {
                callback(url,fp,nil);
            }
            return nil;
        }
    }
    self.image = placeholderImage;
    id requestTask = [[UIImageView imageDownloadManager]
     download:url
     progress:nil
     success:^(id  _Nonnull task, NSURL *_Nullable fp) {
         if ( fp && [[fp path] fileExists]) {
             [self setImage:[UIImage imageWithContentsOfFile:[fp path]]];
         }
         if (callback) {
             callback(url, [fp path], nil);
         }
     }
     failure:^(id  _Nullable task, NSURL *_Nullable fp, NSError * _Nonnull error) {
         if ( fp && [[fp path] fileExists]) {
             [self setImage:[UIImage imageWithContentsOfFile:[fp path]]];
         }
         if (callback) {
             callback(url, [fp path], error);
         }
         
     }];
    [self setRequestTask:requestTask];
    return nil;
}
- (void)setImageURLString:(NSString *)url{
    [self setImageURLString:url placeholderImage:nil withImageLoadedCallback:nil];
}
- (void)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage{
    [self setImageURLString:url placeholderImage:placeholderImage withImageLoadedCallback:nil];
}

- (id)setImageURLString:(NSString *)url withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback{
    return [self setImageURLString:url placeholderImage:nil withImageLoadedCallback:callback];
}

+ (NSString *)cachePathForURLString:(NSString *)url{
    return [BHttpRequestCacheHandler cachePathForURL:[NSURL URLWithString:url]];
}
+ (NSData *)cacheDataForURLString:(NSString *)url{
    return [BHttpRequestCacheHandler cacheDataForURL:[NSURL URLWithString:url]];
}
@end
