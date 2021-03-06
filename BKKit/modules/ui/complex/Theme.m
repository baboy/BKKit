//
//  Theme.m
//  BCommon
//
//  Created by baboy on 13-8-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "Theme.h"
#import "BKKitDefines.h"
#import "UIImage+x.h"
#import "Utils.h"
#import "DBCache.h"
#import "UIColor+x.h"
#import "NSString+x.h"
#import "XUIButton.h"
#import "XUILabel.h"
#import "UIBarButtonItem+x.h"


@implementation Theme
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)theme{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.theme.plist", theme]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        [DBCache setValue:v forKey:k domain:@"Theme"];
    }
}
+ (void)setup{
    [self setup:@"default"];
}

+ (UIColor *) color:(NSString *)v{
    UIColor *color = nil;
	if ([v length] > 0) {
        if ([v hasPrefix:@"#"]) {
            return [UIColor colorFromString:v];
        }
		NSArray *arr = [v split:@","];
        if ([arr count]==1 && (v.length>=6)) {
            color = [UIColor colorFromString:v];
        }else{
            NSInteger n = [arr count];
            float r,g,b,a;
            r = n>0?[[arr objectAtIndex:0] floatValue]:0;
            g = n>1?[[arr objectAtIndex:1] floatValue]:0;
            b = n>2?[[arr objectAtIndex:2] floatValue]:0;
            a = n>3?[[arr objectAtIndex:3] floatValue]:1;
            color = [UIColor colorWithRed:(r>1?(r/255.0):r) green:(g>1?(g/255.0):g) blue:(b>1?(b/255.0):b) alpha:a];
        }
		return color;
	}
	return nil;
}
+ (UIColor *)colorForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
    if (!v) {
        v = [DBCache valueForKey:[NSString stringWithFormat:@"%@-color", key] domain:@"Theme"];
    }
    return [self color:v];
}
//形如 16,1代表 16号粗体 16或者16,0 代表16号标准字体
+ (UIFont *)fontForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
    if (!v) {
        v = [DBCache valueForKey:[NSString stringWithFormat:@"%@-font", key] domain:@"Theme"];
    }
	if ([v length] > 0) {
		NSArray *arr = [v split:@","];
		NSInteger n = [arr count];
        NSString *family = nil;
        float fsize=14;
        UIFont *font =  nil;
        int b=0;
        int i = 0;
        if (![arr[i] isDigital]) {
            family = arr[i++];
        }
        if (n>i) {
            fsize = [arr[i++] floatValue];
        }
        if (n>i) {
            b = [arr[i] intValue];
        }
        if (family) {
            font = [UIFont fontWithName:family size:fsize];
        }
        if (!font) {
            font =  b>0?[UIFont boldSystemFontOfSize:fsize]:[UIFont systemFontOfSize:fsize];
        }
		return font;
	}
	return [UIFont systemFontOfSize:14];
}

+ (UIImage *) imageForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
    if (!v) {
        return nil;
    }
    if ([v hasPrefix:@"#"] || [v rangeOfString:@","].length>0) {
        UIImage *image = [UIImage imageWithColor:[self color:v] size:CGSizeMake(10, 10)];
        [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
        return image;
    }
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:v] ) {
        UIImage *image  = [UIImage imageNamed:v];
        return image;
    }
    if (v) {
        UIImage *image = [UIImage imageWithContentsOfFile:v];
        return image;
    }
    return nil;
}

+ (int) intValueForKey:(NSString *)key{
    return [[self valueForKey:key] intValue];
}
+ (float) floatValueForKey:(NSString *)key{
    return [[self valueForKey:key] floatValue];
}
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key withTarget:(id)target action:(SEL)action{
    
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
    if (!v) {
        v = key;
    }
    return createBarImageButtonItem(v, target, action);
}
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key{
    return [Theme navBarButtonForKey:key withTarget:nil action:nil];
}
+ (UIButton *) buttonForKey:(NSString *)key withTarget:(id)target action:(SEL)action{
    NSString *v = [DBCache valueForKey:key domain:@"Theme"];
    if (!v) {
        v = key;
    }
    UIButton *btn = createImageButton(CGRectZero, v, target, action);
    return btn;
}
+ (UIButton *) buttonForKey:(NSString *)key{
    return [Theme buttonForKey:key withTarget:nil action:nil];
}

+ (UIButton *) buttonWithTitle:(NSString *)title background:(NSString *)imageName  target:(id)target action:(SEL)action{
    UIButton *btn = createButton(CGRectZero, title, imageName, target, action);
    [btn setTitleColor:[Theme colorForKey:@"button-title-color"] forState:UIControlStateNormal];
    [btn setTitleColor:[Theme colorForKey:@"button-title-color-selected"] forState:UIControlStateSelected];
    return btn;
}

+ (UILabel *) labelForStyle:(NSString *)style{
    return createLabel(CGRectZero,
                [self fontForKey:[NSString stringWithFormat:@"%@-title-font",style]],
                 nil,
                 [self colorForKey:[NSString stringWithFormat:@"%@-title-color",style]],
                [self colorForKey:[NSString stringWithFormat:@"%@-title-shadow-font",style]],
                 CGSizeMake(0, 1),
                 NSTextAlignmentCenter,
                 1, NSLineBreakByTruncatingTail);
}
+ (UIButton *) buttonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action{
    UIFont *titleFont = [Theme fontForKey:[NSString stringWithFormat:@"button-%@-title-font", style]];
    UIColor *titleColor = [Theme colorForKey:[NSString stringWithFormat:@"button-%@-title-color", style]];
    id background = [Theme colorForKey:[NSString stringWithFormat:@"button-%@-background-color", style]];
    if (!background) {
        background = [DBCache valueForKey:[NSString stringWithFormat:@"button-%@-background-image", style] domain:@"Theme"];
    }
    UIButton *btn = createButton(frame, title, background, target, action);
    if (titleFont)
        btn.titleLabel.font = titleFont;
    if (titleColor)
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}
+ (UIBarButtonItem *) navButtonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action{
    UIButton *btn = [self buttonForStyle:style withTitle:title frame:frame target:target action:action];
    UIFont *font = [Theme fontForKey:@"navbar-item-title-font"];
    btn.titleLabel.font = font;
    UIBarButtonItem *barBtn = /*AUTORELEASE*/([[UIBarButtonItem alloc] initWithCustomView:btn]);
    return barBtn;
}
+ (id)valueForKey:(NSString *)key{
    return [DBCache valueForKey:key domain:@"Theme"];
}
@end
