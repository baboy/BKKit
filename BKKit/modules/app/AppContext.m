//
//  Conf.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AppContext.h"
#import "BKKitDao.h"
#import "Utils.h"
#import "NSString+x.h"
#import "Global.h"

@implementation AppContext

+ (BOOL) setNs:(NSString *)ns{
    return [DBCache setValue:ns forKey:@"app_namespace"];
}
+ (NSString *)ns{
    return [DBCache valueForKey:@"app_namespace"];
}
+ (void) setDeviceToken:(NSString *)deviceToken{
    [DBCache setValue:deviceToken forKey:@"device_token"];
}
+ (NSString *) deviceToken{
    return [DBCache valueForKey:@"device_token"];
}
@end

@implementation AppCache
+ (NSString *) cachePath:(NSString *)fn{
    if ([fn isURL]) {
        fn = [NSString stringWithFormat:@"%@.%@",[fn md5],[fn pathExtension]];
    }
    if([fn fileExists]){
        return fn;
    }
    NSString *fp = getFilePath(FILE_CACHE_DIR, fn, nil);
    return fp;
}
+ (NSString *) crateCachePathWithExtension:(NSString *)ext{
    NSString *fn = [NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], ext];
    return [self cachePath:fn];
}
@end
