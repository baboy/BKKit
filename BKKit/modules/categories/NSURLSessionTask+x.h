//
//  NSURLSessionTask+x.h
//  Pods
//
//  Created by baboy on 1/20/16.
//
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask(x)

- (id)userInfo ;
- (void)setUserInfo:(id)userInfo;

- (NSUUID *)uuid ;
- (void)setUUID:(NSUUID *)uuid;
@end
