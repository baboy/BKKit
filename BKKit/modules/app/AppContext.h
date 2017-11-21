//
//  Conf.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContext : NSObject
// App namespace
+ (BOOL) setNs:(NSString *)ns;
+ (NSString *)ns;
+ (void) setDeviceToken:(NSString *)deviceToken;
+ (NSString *) deviceToken;
@end

@interface AppCache : NSObject
+ (NSString *) cachePath:(NSString *)fn;
+ (NSString *) crateCachePathWithExtension:(NSString *)ext;
@end