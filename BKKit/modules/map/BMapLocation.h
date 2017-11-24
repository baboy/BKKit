//
//  CourseLocation.h
//  course
//
//  Created by Yinghui Zhang on 8/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BMapLocation : NSObject
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *district;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dict;
+ (BMapLocation *)currentLocation;
+ (void)saveCurrentLocation:(BMapLocation *)location;
+ (id)getLocationByIpSuccess:(void (^)(BMapLocation *loc))success failure:(void (^)(NSError *error))failure;
+ (id)search:(NSString *)location callback:(void (^)(id task, NSArray *locs, NSError *error))callback;
@end
