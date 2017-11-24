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
+ (void)setConf:(NSString *)conf;
@end


extern void add_app_start_times(void);
extern int get_app_start_times(void);
extern void add_current_app_start_times(void);
extern int get_current_app_start_times(void);
extern void set_current_app_comment(int level);
extern int get_current_app_comment(void);


