//
//  BUser.h
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "BKKitHttp.h"

#define Uid         [[BUser loginUser] uid]?:@""
#define UKey        [[BUser loginUser] ukey]?:@""
#define USER        [BUser loginUser]

#define UserParams  [NSMutableDictionary dictionaryWithObjectsAndKeys:UKey, @"ukey", nil]


@interface BUser : Model
@property (nonatomic, assign) long long uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *ukey;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *avatarThumbnail;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSDictionary *metadata;

+ (BOOL)isLogin;
//当前登录用户
+ (id) loginUser;
//用该用户信息登录
+ (BOOL)loginWithUser:(BUser *)user;
//登出
+ (void)logout;
+ (void)checkLoginWithCallback:(void (^)(BUser* user,NSError *error))callback;

//登录调用
+ (id)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser* user, NSError *error))success failure:(void (^)(NSError *error))failure;
//注册
+ (id)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser* user,NSError *error))success failure:(void (^)(NSError *error))failure;

@end
