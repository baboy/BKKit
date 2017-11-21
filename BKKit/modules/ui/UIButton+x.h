//
//  UIButton+x.h
//  iLookForiPad
//
//  Created by baboy on 13-3-20.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIButton(x)
- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)setImageURLString:(NSString *)url forState:(UIControlState)state;
- (void)setImageURLString:(NSString *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state;
- (void)setBackgroundImageURLString:(NSString *)url forState:(UIControlState)state;
- (void)setBackgroundImageURLString:(NSString *)url
                  placeholder:(UIImage*)placeholder
                     forState:(UIControlState)state;
 
@end
