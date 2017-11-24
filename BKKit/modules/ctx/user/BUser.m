//
//  BUser.m
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BUser.h"
#import "BKKitDefines.h"
#import "BApi.h"
#import "BHttpRequestManager.h"
#import "DBCache.h"
#import "Utils.h"
#import "NSString+x.h"
#import "NSDictionary+x.h"

#define ApiLogin    [BApi apiForKey:@"login"]
#define ApiRegister [BApi apiForKey:@"register"]

static id _current_user = nil;

@implementation BUser
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    return YES;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if ( self = [super initWithDictionary:dict] ) {
        if (!self.desc) {
            [self setDesc:nullToNil([dict valueForKey:@"description"])];
        }
    }
    return self;
}
- (NSString *)displayName{
    if (!_displayName || _displayName.length==0) {
        if (self.nickname && self.nickname.length>0) {
            return self.nickname;
        }
        return self.name;
    }
    return _displayName;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    [self setValue:value forKeyPath:keyPath];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [super setValue:value forUndefinedKey:key];
}
+ (BOOL)isLogin{
    return USER?YES:NO;
}
+ (id)loginUser{
    @synchronized(self){
        if (!_current_user) {
            NSDictionary *json = [[DBCache valueForKey:@"USER"] json];
            if (json){
                NSString *uc = [DBCache valueForKey:@"USER_CLASS"];
                if (!uc)
                    uc = NSStringFromClass([self class]);
                Class userClass = NSClassFromString(uc);
                _current_user = [[userClass alloc] initWithDictionary:json];
            }
        }
    }
    return _current_user;
}
+ (void)updateProfile:(BUser *)user{
    NSString *data = [[user dict] jsonString];
    DLOG(@"%@", data);
    if (data) {
        _current_user = user;
        [DBCache setValue:data forKey:@"USER"];
        [DBCache setValue:NSStringFromClass([user class]) forKey:@"USER_CLASS"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyUserProfileUpdated object:nil];
        return;
    }
}
+ (BOOL)loginWithUser:(BUser *)user{
    @synchronized(self){
        if (user) {
            if ([self loginUser] && user) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserWillChange object:nil];
            }
            NSString *data = [[user dict] jsonString];
            //DLOG(@"%@", data);
            if (data) {
                _current_user = user;
                [DBCache setValue:data forKey:@"USER"];
                [DBCache setValue:NSStringFromClass([user class]) forKey:@"USER_CLASS"];
                ////
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogin object:nil];
                return YES;
            }else{
                DLOG(@"error");
            }
        }
    }
    return NO;
}
+ (void)logout{
    [DBCache removeForKey:@"USER"];
    if (_current_user) {
        _current_user = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogout object:nil];
    }
}
+ (void)checkLoginWithCallback:(void (^)(BUser* user,NSError *error))callback{
}
+ (id)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser *, NSError *))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"username":uname,@"password":pwd};
    return [[BHttpRequestManager defaultManager]
     getJson:ApiLogin
     parameters:params
     success:^(id  _Nonnull task, id  _Nullable json) {
         
     }
     failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
         
     }];
}
+ (id)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser *, NSError *))success failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"username":uname,@"password":pwd,@"email":email};
    return [[BHttpRequestManager defaultManager]
            POST:ApiRegister
            parameters:params
            progress:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
}
@end
