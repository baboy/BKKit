//
//  BMapPlace.m
//  BCommon
//
//  Created by baboy on 13-7-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BMapPlace.h"
#import "NSString+x.h"
#import "Utils.h"
#import "BApi.h"

@implementation BMapPlace
- (void)dealloc{
    ////
    ////
    ////
    ////
    ////
    ////
    //[super dealloc];
}
- (id) initWithDictionary:(NSDictionary*)dict{
    if(self = [super init]){
        [self setAddress:[dict valueForKey:@"formatted_address"]];
        [self setLat:[[dict valueForKeyPath:@"geometry.location.lat"] doubleValue]];
        [self setLng:[[dict valueForKeyPath:@"geometry.location.lng"] doubleValue]];
        [self setIcon:nullToNil([dict valueForKey:@"icon"])];
        [self setId:nullToNil([dict valueForKey:@"id"])];
        [self setName:nullToNil([dict valueForKey:@"name"])];
        [self setReference:nullToNil([dict valueForKey:@"reference"])];
        [self setVicinity:nullToNil([dict valueForKey:@"vicinity"])];
        [self setTypes:nullToNil([dict valueForKey:@"types"])];
    }
    return self;
}
- (NSDictionary *) dict{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:7];
    [d setValue:[NSNumber numberWithDouble:self.lat] forKey:@"lat"];
    [d setValue:[NSNumber numberWithDouble:self.lng] forKey:@"lng"];
    if(self.icon)
        [d setValue:self.icon forKey:@"icon"];
    if(self.address)
        [d setValue:self.address forKey:@"address"];
    if(self.id)
        [d setValue:self.id forKey:@"id"];
    if(self.name)
        [d setValue:self.name forKey:@"name"];
    if(self.reference)
        [d setValue:self.reference forKey:@"reference"];
    if(self.types)
        [d setValue:self.types forKey:@"types"];
    if(self.vicinity)
        [d setValue:self.vicinity forKey:@"vicinity"];
    return d;
}
+ (BHttpRequestOperation *)search:(NSString *)location success:(void (^)(id task,NSArray *locs, NSError *error))success failure:(void (^)(id task, NSError *error))failure{
    NSString *url = [ApiQueryLocation URLStringWithParam:@{@"loc":location}];
    return [[BHttpRequestManager defaultManager]
            getJson:url
            parameters:nil
            success:^(id  _Nonnull task, id  _Nullable json) {
                HttpResponse *response = [HttpResponse responseWithDictionary:json];
                NSMutableArray *addrs = nil;
                NSError *error = response.error;
                if (response.isSuccess) {
                    NSDictionary *data = response.data;
                    NSArray *list = [data valueForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]]) {
                        addrs = [NSMutableArray array];
                        NSInteger n = [list count];
                        for (int i=0; i<n; i++) {
                            BMapPlace *loc = /*AUTORELEASE*/([[BMapPlace alloc] initWithDictionary:[list objectAtIndex:i]]);
                            [addrs addObject:loc];
                        }
                    }
                }
                if ( !addrs || [addrs count] ==0 ) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"未获取到地址信息", nil)};
                    error = [NSError errorWithDomain:HttpRequestDomain code:-1 userInfo:userInfo];
                }
                success(task, addrs, error);
            } failure:^(id  _Nullable task, id  _Nullable json, NSError * _Nonnull error) {
                failure(task, error);
            }];
}
@end
