//
//  UIButton+x.m
//  iLookForiPad
//
//  Created by baboy on 13-3-20.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIButton+x.h"
#import <objc/runtime.h>
#import "NSString+x.h"
#import "UIImageView+cache.h"
#import "UIImage+x.h"
#import "Theme.h"
#import "BHttpRequestManager.h"
#import "XUILabel.h"
#import "XUIButton.h"



@implementation UIButton (x)

+ (id)imageDownloadManager {
    static id _imageDownloadManager = nil;
    static dispatch_once_t initOnceImageDownloadManager;
    dispatch_once(&initOnceImageDownloadManager, ^{
        _imageDownloadManager = [[BHttpRequestManager alloc] init];
    });
    return _imageDownloadManager;
}
- (void)setDownloadTask:(id)task forState:(UIControlState)state isBackgroundImage:(BOOL)isBackground{
    NSString *field = [NSString stringWithFormat:@"task_%d_%lu",isBackground,(unsigned long)state];
    const char *key = [field UTF8String];
    objc_setAssociatedObject(self, key, task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)taskForState:(UIControlState)state isBackgroundImage:(BOOL)isBackground{
    NSString *field = [NSString stringWithFormat:@"task_%d_%lu",isBackground,(unsigned long)state];
    const char *key = [field UTF8String];
    return (id)objc_getAssociatedObject(self, key);

}
- (void)centerImageAndTitle:(float)spacing{
    CGSize imageSize = self.imageView.frame.size;
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0 , 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}
- (void)centerImageAndTitle{
    [self centerImageAndTitle:3.0];
}
- (void)setImageURLString:(NSString *)url background:(BOOL)flag forState:(UIControlState)state{
    if (!url) {
        return;
    }
    UIImage *image = nil;
    if ( [url fileExists] ) {
        image = [UIImage imageWithContentsOfFile:url];
    }else{
        NSString *fp = [UIImageView cachePathForURLString:url];
        if ([fp fileExists]) {
            image = [UIImage imageWithContentsOfFile:fp];
        }
    }
    if (image) {
        if (flag) {
            [self setBackgroundImage:image forState:state];
        }else{
            [self setImage:image forState:state];
        }
        return;
    }
    @synchronized(self) {
        id task = [self taskForState:state isBackgroundImage:flag];
        if (task) {
            [task cancel];
            [self setDownloadTask:nil forState:state isBackgroundImage:flag];
        }
        task = [[UIButton imageDownloadManager]
                download:url
                progress:nil
                success:^(id  _Nonnull task, NSURL *_Nullable fp) {
                    UIImage *image = [UIImage imageWithContentsOfFile:[fp path]];
                    if (image){
                        if (flag) {
                            [self setBackgroundImage:image forState:state];
                        }else{
                            [self setImage:image forState:state];
                        }
                    }
                }
                failure:^(id  _Nullable task, id  _Nullable fp, NSError * _Nonnull error) {
                    
                }];
        [self setDownloadTask:task forState:state isBackgroundImage:flag];
    }
}
- (void)setImageURLString:(NSString *)url placeholder:(UIImage*)placeholder background:(BOOL)flag forState:(UIControlState)state{
    if (placeholder) {
        if (flag) {
            [self setBackgroundImage:placeholder forState:state];
        }else{
            [self setImage:placeholder forState:state];
        }
    }
    [self setImageURLString:url background:flag forState:state];
}
- (void)setImageURLString:(NSString *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURLString:url placeholder:placeholder background:NO forState:state];
}
- (void)setBackgroundImageURLString:(NSString *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURLString:url placeholder:placeholder background:YES forState:state];
}
- (void)setImageURLString:(NSString *)url forState:(UIControlState)state{
    [self setImageURLString:url placeholder:nil background:NO forState:state];
    
}
- (void)setBackgroundImageURLString:(NSString *)url forState:(UIControlState)state{
    [self setImageURLString:url placeholder:nil background:YES forState:state];
    
}
@end



