//
//  BProgressBar.h
//  itv
//
//  Created by Zhang Yinghui on 11-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BProgressBar : UIView

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) float padding;
@property (nonatomic, assign) double progress;
@end

@interface CircleProgressBar : BProgressBar
@property (nonatomic, strong) UIColor *backgroundStrokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@end


@interface VolumeCircleProgressBar : BProgressBar
@property (nonatomic, assign) CGFloat strokeWidth;
@end