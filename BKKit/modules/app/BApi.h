//
//  Api.h
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BApi :                          NSObject
+ (void)setup:(NSString                    *)plist;
+ (BOOL)setCommonParams:(NSDictionary *)params;
+ (NSString *)apiForKey:(NSString          *)key;
+ (NSString *)apiForKey:(NSString          *)key withParam:(NSDictionary *)param;
@end
extern NSString * getApi(NSString *key, NSDictionary *param);
