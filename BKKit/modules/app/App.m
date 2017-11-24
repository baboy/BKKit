//
//  AppCache.m
//  BKKit
//
//  Created by baboy on 23/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#import "App.h"
#import "BKKitDefines.h"
#import "DBCache.h"
#import "Utils.h"
#import "NSString+x.h"

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


@implementation NamespaceDao
+ (BOOL) setNs:(NSString *)ns{
    return [DBCache setValue:ns forKey:@"app_namespace"];
}
+ (NSString *)ns{
    return [DBCache valueForKey:@"app_namespace"];
}
+ (FMDatabase*)db{
    NSString *ns = [self ns];
    return [self db:ns];
}

@end
