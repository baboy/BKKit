//
//  Api.m
//  iNews
//
//  Created by baboy on 13-4-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BApi.h"
#import "BKKitDefines.h"
#import "DBCache.h"
#import "NSString+x.h"
#import "Utils.h"
#import "NSArray+x.h"
#import "Global.h"

@implementation BApi
+ (Class)handler{
    NSString *clazz = [DBCache valueForKey:@"handler" domain:@"api"];
    if (clazz) {
        Class c = NSClassFromString(clazz);
        if (c) {
            return c;
        }
    }
    return self;
}
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)plist{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.api.plist", plist]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    NSString *server = [conf valueForKey:@"server"];
    NSArray *ignores = @[@"server", @"handler"];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        if (!v || [v length]==0) {
            continue;
        }
        if (![ignores containsStringIgnoreCase:k] && ![v isURL] && server) {
            v = [NSString stringWithFormat:@"%@%@", server, v];
        }
        [DBCache setValue:v forKey:k domain:@"api"];
    }
}
+ (void)setup{
    [self setup:@"default"];
}

+ (BOOL)setCommonParams:(NSDictionary *)params{
    [G setValue:params forKey:@"api_common_params"];
    return true;
}
+ (NSDictionary *)commonParams{
    NSDictionary *d = [G valueForKey:@"api_common_params"];
    return d;
}

+ (NSString *)apiForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"api"];
    NSString *url = [v URLStringWithParam:[self commonParams]];
	return url;
}
+ (NSString *)apiForKey:(NSString*)key withParam:(NSDictionary *)param{
    NSString *v = [self apiForKey:key];
    if (param) {
        v = [v URLStringWithParam:param];
    }
    return v;
}
@end

NSString * getApi(NSString *key, NSDictionary *param){
    return [[BApi handler] apiForKey:key withParam:param];
}
