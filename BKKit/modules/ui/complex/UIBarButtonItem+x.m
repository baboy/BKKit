//
//  UIBarButtonItem+x.m
//  BKKit
//
//  Created by baboy on 24/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#import "UIBarButtonItem+x.h"
#import "Theme.h"
#import "XUIButton.h"
@implementation UIBarButtonItem(x)

@end
UIBarButtonItem * createBarButtonItem(NSString *title,id target,SEL action){
    //UIImage *btnBg = [UIImage imageNamed:@"btn_bg.png"];
    //[btnBg stretchableImageWithLeftCapWidth:btnBg.size.height/2 topCapHeight:btnBg.size.width/2];
    CGSize tsize = [title sizeWithFont:gButtonTitleFont];
    CGRect rect = CGRectMake(0, 0, tsize.width+12, 28);
    
    UIButton *btn = [[XUIButton alloc] initWithFrame:rect] ;
    //[btn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:gButtonTitleFont];
    [btn setTitleColor:gButtonTitleColor  forState:UIControlStateNormal];
    [btn.layer setBorderColor:[UIColor colorWithWhite:0.96 alpha:1.0].CGColor];
    [btn.layer setBorderWidth:1.0];
    //[btn setTitleShadowColor:gButtonTitleShadowColor forState:UIControlStateNormal];
    // [btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [item setTarget:target];
    [item setAction:action];
    return item ;
}
UIBarButtonItem * createBarImageButtonItem(NSString *iconName,id target,SEL action){
    UIButton *btn = createImageButton(CGRectZero, iconName, target, action);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //[item setTarget:target];
    //[item setAction:action];
    return item ;
}
