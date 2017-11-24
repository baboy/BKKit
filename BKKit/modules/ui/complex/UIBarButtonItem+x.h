//
//  UIBarButtonItem+x.h
//  BKKit
//
//  Created by baboy on 24/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem(x)

@end
extern UIBarButtonItem * createBarButtonItem(NSString *title,id target,SEL action);
extern UIBarButtonItem * createBarImageButtonItem(NSString *iconName,id target,SEL action);
