//
//  UIImageView+cache.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(cache)
- (void)setImageURLString:(NSString *)url;
- (void)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage;
- (id)setImageURLString:(NSString *)url withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback;
- (id)setImageURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSString *url, NSString *filePath, NSError *error))callback;

+ (NSString *)cachePathForURLString:(NSString *)url;
+ (NSData *)cacheDataForURLString:(NSString *)url;
@end
