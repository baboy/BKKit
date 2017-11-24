//
//  BProgressBar.m
//  itv
//
//  Created by Zhang Yinghui on 11-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BProgressBar.h"
#define nCircleSlice 60
@interface BProgressBar()
@property (nonatomic, strong) UIColor *backgroundColor;
@end

@implementation BProgressBar

- (void)setup{
    
    if (!self.barColor && [self respondsToSelector:@selector(tintColor)]){
        self.barColor = self.tintColor;
    }else if(!self.barColor){
        self.barColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    }
    self.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setup];
        self.padding = 2;
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    self.padding = self.tag;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
    _backgroundColor = backgroundColor;
}
- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setNeedsDisplay];
}
- (void)setBorderColor:(UIColor *)borderColor{
    ////
    _borderColor = borderColor ;
    self.layer.borderWidth = 1.0;
    [self.layer setBorderColor:borderColor.CGColor];
}
- (void)setBarColor:(UIColor *)barColor{
    ////
    _barColor = barColor ;
    [self setNeedsDisplay];
}
- (void)setProgress:(double)progress{
    _progress = progress;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	//CGContextSetShouldAntialias(ctx, false );
    [self.backgroundColor set];
    CGContextFillRect(ctx, rect);
    
    [self.barColor set];
    CGRect barFrame = CGRectInset(rect, self.padding, self.padding);
    barFrame.size.width *= self.progress;
    barFrame.size.width = MAX(barFrame.size.width, 3);
	CGContextFillRect(ctx, barFrame);
}
@end

@implementation CircleProgressBar
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
- (void)setup{
    self.backgroundStrokeColor = [UIColor lightGrayColor];
    self.strokeWidth = 5;
    self.barColor = [UIColor blueColor];
    self.textFont = [UIFont systemFontOfSize:12];
    self.textColor = [UIColor grayColor];
    
}
- (void)setBorderColor:(UIColor *)borderColor{
}
- (void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor{
    _backgroundStrokeColor = backgroundStrokeColor;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    
    CGFloat centerX = rect.size.width/2, centerY = rect.size.height/2;
    CGFloat rad = MIN(centerX - self.strokeWidth/2, centerY - self.strokeWidth/2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, self.strokeWidth);
    
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.backgroundStrokeColor.CGColor);
    CGContextAddArc(ctx, centerX, centerY, rad, -M_PI/2, -M_PI/2+2*M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextSetStrokeColorWithColor(ctx, self.barColor.CGColor);
    CGContextAddArc(ctx, centerX, centerY, rad, -M_PI/2, -M_PI/2+self.progress*2*M_PI, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
    int p = (int)(self.progress*100);
    p = MAX(0, p);
    p = MIN(100, p);
    NSLog(@"progress:%f",self.progress);
    NSString *s = [NSString stringWithFormat:@"%d%%",p];
    CGSize tSize = [s sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    [self.textColor set];
    [s drawAtPoint:CGPointMake((rect.size.width-tSize.width)/2, (rect.size.height-tSize.height)/2) withAttributes:@{NSFontAttributeName:self.textFont}];
    
    
}
@end

@implementation VolumeCircleProgressBar
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
- (void)setup{
    [super setup];
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.strokeWidth = 5;
}
- (void)drawRect:(CGRect)rect{
    //计算画进度条区域
    CGFloat centerX = rect.size.width/2, centerY = rect.size.height/2;
    CGFloat rad = MIN(centerX , centerY );
    CGFloat sliceAngle = 2*M_PI/nCircleSlice;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画背景
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextAddArc(ctx, centerX, centerY, rad, 0, 2*M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    rad -= self.strokeWidth/2+2;
    CGContextSetLineWidth(ctx, self.strokeWidth);
    CGContextSetStrokeColorWithColor(ctx, self.barColor.CGColor);
    int n = 2*M_PI*self.progress/sliceAngle;
    for (int i = 0; i < n; i++) {
        CGFloat startAngle = -M_PI/2+i*sliceAngle;
        CGFloat endAngle = startAngle + sliceAngle/2;
        CGContextAddArc(ctx, centerX, centerY, rad, startAngle, endAngle, 0);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
}
@end