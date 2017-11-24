//
//  XUIButton.m
//  BKKit
//
//  Created by baboy on 23/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#import "XUIButton.h"
#import "UIImage+x.h"
#import "Theme.h"

@implementation XUIButton
- (void)dealloc{
    ////
    //[super dealloc];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *backgroundImage = [self backgroundImageForState:UIControlStateNormal];
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
    [super setBackgroundImage:image forState:state];
}
- (void)relayout{
    if (self.textAlignStyle == UIButtonTextAlignmentStyleHorizontal) {
        return;
    }
    UIImage *image = self.currentImage;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float labelWidth = self.titleLabel.bounds.size.width;
    float labelHeight = self.titleLabel.bounds.size.height;
    float vPadding = (self.bounds.size.height - labelHeight-imageHeight)/3;
    self.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight/2-vPadding,labelWidth/2,labelHeight/2+vPadding,-labelWidth/2);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.size = titleSize;
    self.titleLabel.frame = labelFrame;
    CGFloat offsetX = (titleSize.width-labelWidth)/2;
    self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight/2+vPadding,-imageWidth/2-offsetX,-imageHeight/2-vPadding,imageWidth/2+offsetX);
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self relayout];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self relayout];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self relayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self relayout];
}
@end

@implementation VerticalButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textAlignStyle = UIButtonTextAlignmentStyleVertical;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignStyle = UIButtonTextAlignmentStyleVertical;
    }
    return self;
}

@end



void setButtonImage(UIButton *button,NSString *imageName, NSString *imageName2, BOOL isBackground){
    UIImage *image = nil, *image2 = nil, *selectImage = nil;
    if ([imageName isKindOfClass:[UIColor class]]) {
        image = [UIImage imageWithColor:(id)imageName size:CGSizeMake(5, 5)];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    }else{
        image = [UIImage imageNamed:imageName];
        if (!image && ![imageName hasSuffix:@"-0"]) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", imageName]];
            if (image) {
                imageName = [NSString stringWithFormat:@"%@-0", imageName];
            }
        }
        if (!imageName2) {
            imageName2 = [imageName stringByReplacingOccurrencesOfString:@"-0" withString:@"-1"];
        }
        image2 = [imageName2 isEqualToString:imageName]?nil:[UIImage imageNamed:imageName2];
        image = image?:[UIImage imageWithContentsOfFile:imageName];
        image2 = image2?:[UIImage imageWithContentsOfFile:imageName2];
        NSString *imageSelectName = [imageName stringByReplacingOccurrencesOfString:@"-0" withString:@"-selected"];
        selectImage = [UIImage imageNamed:imageSelectName];
    }
    
    if (isBackground) {
        image = image?[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)]:nil;
        image2 = image2?[image2 resizableImageWithCapInsets:UIEdgeInsetsMake(image2.size.height/2, image2.size.width/2, image2.size.height/2, image2.size.width/2)]:image;
        selectImage = selectImage?[selectImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectImage.size.height/2, selectImage.size.width/2, selectImage.size.height/2, selectImage.size.width/2)]:image;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    }else{
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image2 forState:UIControlStateHighlighted];
        [button setImage:selectImage forState:UIControlStateSelected];
    }
}

UIButton *createImageButton(CGRect frame, NSString *imageName, id target, SEL action){
    if (frame.size.width == 0 || frame.size.height == 0) {
        frame.size = sizeOfImage(imageName);
    }
    UIButton *btn = createButton(frame, nil,imageName, target, action);
    return btn;
}
UIButton *createButton(CGRect frame, NSString *title, id imgName,id target, SEL action){
    if ( (frame.size.width == 0 || frame.size.height == 0) && [title length] > 0 ) {
        CGSize size = title ? [title sizeWithFont:gButtonTitleFont] : CGSizeMake(48, 28);
        frame = CGRectMake(0,0, MAX(size.width+20, 44), size.height+10);
    }
    if ( ( !title || [title isEqualToString:@""] ) && ![imgName isKindOfClass:[UIColor class]] ) {
        UIImage *backgroundImage = [UIImage imageNamed:imgName];
        if (backgroundImage) {
            frame.size = CGSizeMake( backgroundImage.size.width, backgroundImage.size.height);
        }
    }
    UIButton *btn = /*AUTORELEASE*/([[XUIButton alloc] initWithFrame:frame]);
    btn.titleLabel.font = gButtonTitleFont;
    btn.titleLabel.textColor = gButtonTitleColor;
    [btn setTitle:title forState:UIControlStateNormal];
    setButtonImage(btn, imgName, nil,title?YES:NO);
    if (target)
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
