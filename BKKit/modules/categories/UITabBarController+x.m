//
//  UITabBarController+x.m
//  Pods
//
//  Created by baboy on 1/21/16.
//
//

#import "UITabBarController+x.h"
#import "Utils.h"
#import "Theme.h"
#import "XUIViewController.h"

@implementation UITabBarController(x)
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = ThemeViewBackgroundColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [Theme colorForKey:@"tabbar_item_title_selected_color"], NSForegroundColorAttributeName,
                                                       [Theme fontForKey:@"tabbar_item_title_selected_font"],NSFontAttributeName,
                                                       
                                                       nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [Theme colorForKey:@"tabbar_item_title_color"], NSForegroundColorAttributeName,
                                                       [Theme fontForKey:@"tabbar_item_title_font"],NSFontAttributeName,
                                                       
                                                       nil] forState:UIControlStateNormal];
}
- (NSArray *) loadViewControllersFromFile:(NSString *)plist{
    NSArray *menus = [NSArray arrayWithContentsOfFile:getBundleFile(plist)];
    NSMutableArray *vcs = [NSMutableArray array];
    for (NSInteger i=0, n = menus.count; i < n; i++) {
        NSDictionary *item = [menus objectAtIndex:i];
        BOOL enable = [[item objectForKey:@"enable"] boolValue];
        if(!enable)
            continue;
        NSString *title = [item valueForKey:@"title"];
        
        NSString *icon = [item valueForKey:@"icon"];
        NSString *iconSelected = [item valueForKey:@"icon_selected"];
        if (!iconSelected)
            iconSelected = icon;
        Class c = NSClassFromString([item valueForKey:@"controller"]);
        if(!c)
            continue;
        UIViewController *vc = [[c alloc] init];
        XUINavigationController *nav = [[XUINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem.image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:iconSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //nav.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        nav.tabBarItem.title = title;
        if (title && title.length) {
            [vc setTitle:title];
        }
        [vcs addObject:nav];
    }
    return vcs;
}
@end
