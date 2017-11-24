//
//  XUIButton.h
//  BKKit
//
//  Created by baboy on 23/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//


#import <UIKit/UIKit.h>
enum  {
    UIButtonTextAlignmentStyleHorizontal,
    UIButtonTextAlignmentStyleVertical
};
typedef NSInteger UIButtonTextAlignmentStyle;

@interface XUIButton:UIButton
@property (nonatomic, retain) id object;
@property (nonatomic, assign) UIButtonTextAlignmentStyle textAlignStyle;
@end
@interface VerticalButton : XUIButton
@end


extern UIButton *createImageButton(CGRect frame, NSString *imageName, id target, SEL action);
extern UIButton *createButton(CGRect frame, NSString *title, id imgName,id target, SEL action);
