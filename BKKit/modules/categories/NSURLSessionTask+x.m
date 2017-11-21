//
//  NSURLSessionTask+x.m
//  Pods
//
//  Created by baboy on 1/20/16.
//
//

#import "NSURLSessionTask+x.h"
#import <objc/runtime.h>

static char NSURLSessionTaskUserInfoKey;
static char NSURLSessionTaskUUIDKey;
@implementation NSURLSessionTask(x)

- (id)userInfo {
    return (id)objc_getAssociatedObject(self, &NSURLSessionTaskUserInfoKey);
}

- (void)setUserInfo:(id)userInfo{
    objc_setAssociatedObject(self, &NSURLSessionTaskUserInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUUID *)uuid {
    return (id)objc_getAssociatedObject(self, &NSURLSessionTaskUUIDKey);
}
- (void)setUUID:(NSUUID *)uuid{
    objc_setAssociatedObject(self, &NSURLSessionTaskUUIDKey, uuid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
@end
