//
//  XUILabel.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "XUILabel.h"

@implementation XUILabel
@synthesize verticalAlignment = _verticalAlignment;
@synthesize caption = _caption;
- (void)dealloc{
    ////
    //[super dealloc];
}

- (void)setVerticalAlignment:(LabelVerticalAlignment)verticalAlignment{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case LabelVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case LabelVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case LabelVerticalAlignmentMiddle:
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect{
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end


UILabel * createLabel(CGRect frame,UIFont *font,UIColor *bg,UIColor *textColor,UIColor *shadow,CGSize shadowSize,int textAlign,int numOfLines,int lineBreakMode){
    frame.origin.x = ceilf(frame.origin.x);
    frame.origin.y = ceilf(frame.origin.y);
    frame.size.width = ceilf(frame.size.width);
    frame.size.height = ceilf(frame.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.backgroundColor = bg?bg:[UIColor clearColor];
    label.textColor = textColor;
    if (shadow) {
        label.shadowColor = shadow;
        label.shadowOffset = shadowSize;
    }
    label.numberOfLines = numOfLines;
    label.lineBreakMode = lineBreakMode;
    label.textAlignment = textAlign;
    return label;
}
