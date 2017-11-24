//
//  AppCache.h
//  BKKit
//
//  Created by baboy on 23/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBCache.h"
#import "OpenUDID.h"

#define AppLink     [DBCache valueForKey:@"app_link"]
#define AppStore    [DBCache valueForKey:@"app_store"]

#define AppBuild    [DBCache valueForKey:@"build"]
#define AppChannel  [DBCache valueForKey:@"channel"]

#define APPID           [DBCache valueForKey:@"appid"]
#define TrackerKey      [DBCache valueForKey:@"tracker_appkey"]
#define DeviceID        [OpenUDID value]
#define DeviceToken     [DBCache valueForKey:@"device_token"]

@interface AppCache : NSObject
+ (NSString *) cachePath:(NSString *)fn;
+ (NSString *) crateCachePathWithExtension:(NSString *)ext;
@end

@interface NamespaceDao:Dao
// App namespace
+ (BOOL) setNs:(NSString *)ns;
+ (NSString *)ns;
@end

