//
//  BImageView.h
//  iLook
//
//  Created by Zhang Yinghui on 7/10/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIView.h"

typedef enum {
    BImageTitleStyleDefault,
    BImageTitleStyleBelow
} BImageTitleStyle;

@interface BImageView : XUIView 
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, retain) NSObject *object;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) BImageTitleStyle titleStyle;
@property (nonatomic, assign) float titleHeight;

- (void) addTarget:(id)target action:(SEL)action;
- (void) setRadius:(float)rad;
- (void) showProgress:(BOOL)showProgress;
@end
