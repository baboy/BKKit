//
//  Theme.h
//  BCommon
//
//  Created by baboy on 13-8-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ThemeNavBarItemTitleColor [Theme colorForKey:@"navigationbar-item-title-color"]
#define ThemeSingleLineColor [Theme colorForKey:@"single-line-color"]
#define ThemeTabBarSelectTitleColor [Theme colorForKey:@"tabbar-select-title-color"]
#define ThemeTabBarUnSelectTitleColor [Theme colorForKey:@"tabbar-unselect-title-color"]
#define ThemeTabBarBackground [Theme imageForKey:@"tabbar-background"]
#define ThemeTabBarSelectedBackground [Theme imageForKey:@"tabbar-background-selected"]
#define ThemeSectionViewBackground [Theme imageForKey:@"table-section-background"]
#define ThemeSectionViewTitleColor [Theme colorForKey:@"table-section-title-color"]
#define gButtonTitleFont            [Theme fontForKey:@"button-title-font"]
#define gButtonTitleColor           [Theme colorForKey:@"button-title-color"]


#define gNavBarBackButton       [Theme navBarButtonForKey:@"navigationbar-back-button"]
#define gPlayerPlayButton       [Theme buttonForKey:@"icon-play"]
#define ThemeNavBarBackButton(target,act) [Theme navBarButtonForKey:@"navigationbar-back-button" withTarget:(target) action:(act)]

//导航栏
#define gNavBarTitleColor          [Theme colorForKey:@"navigationbar-title-color"]
#define gNavBarTitleFont           [Theme fontForKey:@"navigationbar-title-font"]
#define gNavBarTitleShadowColor          [Theme colorForKey:@"navigationbar-title-shadow-color"]
#define gNavBarBackgroundImage  [Theme imageForKey:@"navigationbar-background"]
#define ThemeViewBackgroundColor    [Theme colorForKey:@"view-background-color"]
// table
#define gTableCellTitleFont     [Theme fontForKey:@"table-cell-title-font"]
#define gTableCellTitleColor    [Theme colorForKey:@"table-cell-title-color"]

#define gTableCellDescFont     [Theme fontForKey:@"table-cell-desc-font"]
#define gTableCellDescColor    [Theme colorForKey:@"table-cell-desc-color"]


#define gTableCellContentFont     [Theme fontForKey:@"table-cell-content-font"]
#define gTableCellContentColor    [Theme colorForKey:@"table-cell-content-color"]

@interface Theme : NSObject
+ (void)setup:(NSString *)theme;
+ (UIColor *) color:(NSString *)val;
+ (UIColor *) colorForKey:(NSString *)key;
+ (UIFont *)  fontForKey:(NSString *)key;
+ (UIImage *) imageForKey:(NSString *)key;
+ (int) intValueForKey:(NSString *)key;
+ (float) floatValueForKey:(NSString *)key;
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key;
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key withTarget:(id)target action:(SEL)action;
+ (UIButton *) buttonForKey:(NSString *)key;
+ (UIButton *) buttonForKey:(NSString *)key withTarget:(id)target action:(SEL)action;
+ (UIButton *) buttonWithTitle:(NSString *)title background:(NSString *)imageName  target:(id)target action:(SEL)action;

+ (UILabel *) labelForStyle:(NSString *)style;

+ (UIButton *) buttonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
+ (UIBarButtonItem *) navButtonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
+ (id)valueForKey:(NSString *)key;
@end
