//
//  G.m
//  iLook
//
//  Created by Zhang Yinghui on 5/27/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "Global.h"
#import "BKKitDefines.h"
#import "Utils.h"
#import "DBCache.h"
#import "App.h"

@interface G()

+ (void) initData;

@end


@implementation G
static NSMutableDictionary *data;
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)plist{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.conf.plist", plist]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        [DBCache setValue:v forKey:k];
    }
}
+ (void)setup{
    [self setup:@"default"];
    [G setValue:DeviceParam forKey:@"device_param"];
    [G setValue:URLCommonParam forKey:@"url_common_param"];
}

+ (void) initData{
	if (!data) {
		data = [[NSMutableDictionary alloc] init];
	}
}
+ (void) setValue:(id) val forKey:(id)key{
	[G initData];
	[data setValue:val forKey:key];
}
+ (id) valueForKey:(id)key{
	id v = data?[data valueForKey:key]:nil;
    if (!v) {
        v = [DBCache valueForKey:key];
    }
	return v;
}
+ (id)remove:(id)key{
    id obj = nil;
    if (data) {
        obj = [self valueForKey:key];
        [data removeObjectForKey:key];
    }
    return obj;
}
+ (NSDictionary *) dict{
	return data;
}

@end


