//
//  RequestStatus.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "HttpResponse.h"
NSString *HttpRequestDomain = @"X-Channel request error";

@interface HttpResponse()
@property (nonatomic, strong) NSString *dataItemClass;

@end

@implementation HttpResponse
-  (id) initWithDictionary:(NSDictionary *)dict dataItemClass:(Class)itemClass{
    [self setDataItemClass:NSStringFromClass(itemClass)];
    if ([super initWithDictionary:dict]) {
        if ([self.data isKindOfClass:[NSDictionary class]] && itemClass && [itemClass isSubclassOfClass:[Model class]]) {
            self.data = [[itemClass alloc] initWithDictionary:self.data];
        }
    }
    return self;
}
+ (id)responseWithDictionary:(NSDictionary *)dict{
    HttpResponse *response = [[HttpResponse alloc] initWithDictionary:dict];
    return response;
}
+ (id)responseWithDictionary:(NSDictionary *)dict dataItemClass:(Class)itemClass{
    HttpResponse *response = [[HttpResponse alloc] initWithDictionary:dict dataItemClass:itemClass];
    return response;
}
- (BOOL)isSuccess{
    return self.status == ResponseStatusCodeSuccess;
}
- (NSError *)error{
    if ([self isSuccess]) {
        return nil;
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:self.msg?self.msg:@""};
    NSError *error = [NSError errorWithDomain:HttpRequestDomain code:self.status userInfo:userInfo];
    return error;
}
@end
