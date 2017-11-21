//
//  BHttpRequestOperation.h
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BHttpRequestCacheHandler.h"

@interface BHttpRequestOperation:NSObject /*: AFHTTPRequestOperation*/
@property (nonatomic, retain) NSString *cacheFilePath;
@property (nonatomic, retain) BHttpRequestCacheHandler *cacheHandler;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSURLRequest* request;
@property (nonatomic, readonly,getter=isReadFromCache) BOOL readFromCache;
@property (nonatomic, readonly) BOOL downloadResume;
- (id)initWithRequest:(NSURLRequest *)request;
//完成网络请求时回调，合并正常完成以及出错完成回调 如果error 不为空则出错
@property (readwrite, nonatomic, copy) void (^finishedCallbackBlock)(BHttpRequestOperation *operation,id data,Boolean isReadFromCache,NSError *error);

@property (readwrite, nonatomic, copy) void (^receiveDataBlock)(BHttpRequestOperation *operation,NSData *data);
@end