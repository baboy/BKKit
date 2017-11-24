//
//  UINavigationController+x.m
//  Pods
//
//  Created by baboy on 1/27/16.
//
//

#import "UINavigationController+x.h"
#import "Theme.h"

@implementation UINavigationController(x)

- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {
        
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backgroundImage.size.height/2, backgroundImage.size.width/2, backgroundImage.size.height/2, backgroundImage.size.width/2)];
        [self.navigationBar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *navigationBarBackground = backgroundImage;
        if (navigationBarBackground)
            [self.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:gNavBarTitleColor,NSFontAttributeName:gNavBarTitleFont};
}
@end
