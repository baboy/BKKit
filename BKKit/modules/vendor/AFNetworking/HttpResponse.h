//
//  RequestStatus.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

extern NSString *HttpRequestDomain;

enum{
    ResponseStatusCodeSuccess=0,
    ResponseStatusCodeFail,
};
typedef int ResponseStatusCode;

@interface HttpResponse : Model
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) id data;
+ (id)responseWithDictionary:(NSDictionary *)dict;
+ (id)responseWithDictionary:(NSDictionary *)dict dataItemClass:(Class)itemClass;
- (BOOL)isSuccess;
- (NSError *)error;
@end
