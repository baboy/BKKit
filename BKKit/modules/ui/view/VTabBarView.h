//
//  VTabBarView.h
//  iLookForiPad
//
//  Created by baboy on 13-2-22.
//  Copyright (c) 2013年 baboy. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol VTabBarViewDelegate;
@interface VTabBarView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign)id<VTabBarViewDelegate>delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) float itemHeight;
@property (nonatomic, assign) float itemBorderWidth;
@property (nonatomic, assign) float spacing;
@property (nonatomic, assign) float separatorHeight;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UIColor *selectedTitleColor;
@property (nonatomic, retain) UIColor *unSelectedTitleColor;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unSelectedImage;
@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, retain) UIColor *separatorTopColor;
@property (nonatomic, retain) UIColor *separatorBottomColor;

- (void) selectAtIndex:(NSInteger)i;
- (void) selectWithValue:(NSString *)v;
@end

@protocol VTabBarViewDelegate<NSObject>
- (void)tabBar:(VTabBarView *)tabBar didSelectItem:(NSDictionary *)info;
@end