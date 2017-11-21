//
//  UIViewController+itv.m
//  itv
//
//  Created by Zhang Yinghui on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XUIViewController.h"
#import "UINavigationBar+x.h"
#import "BKKitCtx.h"
#import "BKKitUI.h"
#import "BKKitCategory.h"
#import "UINavigationController+x.h"

@implementation XUINavigationController
- (id) initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setNavigationBarBackgroundImage:gNavBarBackgroundImage];
    }
    return self;
}
- (id) init{
    if (self = [super init]) {
        [self setNavigationBarBackgroundImage:gNavBarBackgroundImage];
    }
    return self;
}
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setNavigationBarBackgroundImage:gNavBarBackgroundImage];
    }
    return self;
}
- (void)setNavBgColor:(UIColor *)color{
    [self.navigationBar setTintColor:color];
}
- (void)popViewController{
    [self popViewControllerAnimated:YES];
}
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if ([[self viewControllers] count] <= 1) {
        return;
    }
    if ([viewController isKindOfClass:[XUIViewController class]]) {
        viewController.navigationItem.leftBarButtonItem = [Theme navBarButtonForKey:@"navigationbar-back-button" withTarget:viewController action:@selector(popViewController:)];
    }
}
- (BOOL)shouldAutorotate{
    UIViewController *vc = self.topViewController;
    if ([vc respondsToSelector:@selector(shouldAutorotate)]) {
        return [vc shouldAutorotate];
    }
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *vc = self.topViewController;
    if ([vc respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [vc supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}
@end
@interface XUIViewController ()
@property (nonatomic, retain) UIView *indicatorView;
@property (nonatomic, retain) NSMutableDictionary *requestPool;
@property (nonatomic, retain) NSString *navTitle;
@end


@implementation XUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.requestPool = [NSMutableDictionary dictionary];
    }
    return self;
}
- (id)init{
    if (self = [super init]) {
        self.requestPool = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {
        
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backgroundImage.size.height/2, backgroundImage.size.width/2, backgroundImage.size.height/2, backgroundImage.size.width/2)];
        [navBar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *navigationBarBackground = backgroundImage;
        if (navigationBarBackground)
            [navBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)loadView{
    [super loadView];
    [self awake];
}
- (void) awake{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	_frame = self.view.bounds;
    if (self.navigationController) {
       // _frame.size.height -= self.navigationController.navigationBar.bounds.size.height;
    }
	if (self.tabBarController && !self.hidesBottomBarWhenPushed) {
		//_frame.size.height -= self.tabBarController.tabBar.frame.size.height;
	}
}
- (void)didReceiveMemoryWarning{
    DLOG(@"didReceiveMemoryWarning & reset");
    [super didReceiveMemoryWarning];
    [self reset];
}
- (void)setDropMenuTitle:(NSString *)title{
    if (!self.navigationItem.titleView || ![self.navigationItem.titleView isKindOfClass:[UIButton class]]) {
        UIView *navBar = self.navigationController.navigationBar;
        BDropTitleView *titleView = [[BDropTitleView alloc] initWithFrame:CGRectMake(0, 0, navBar.bounds.size.width/2, navBar.bounds.size.height)];
        [titleView addTarget:self action:@selector(showDropMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = titleView;
    }
    [self setTitle:title];
}
- (void)setTitleLabel:(UILabel *)titleLabel{
    ////
    _titleLabel = titleLabel;
    self.navigationItem.titleView = titleLabel;
    titleLabel.text = self.navTitle;
}
- (void)setTitle:(NSString *)title withImageURL:(NSURL *)imageURL{
    float iconWidth = 32, gap = 5;
    float w = iconWidth, x = 0;
    if (title) {
        w += [title sizeWithFont:gNavBarTitleFont].width+gap;
    }
    w = MIN(w, self.navigationController.navigationBar.bounds.size.width*0.66);
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 40)];
    
    CGRect imgFrame = CGRectMake(0, titleView.bounds.size.height/2-iconWidth/2, iconWidth, iconWidth);
    XUIImageView *thumbImageView = [[XUIImageView alloc] initWithFrame:imgFrame];
    thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [thumbImageView setImageURLString:[imageURL absoluteString]];
    
    [titleView addSubview:thumbImageView];
    thumbImageView = nil;
    
    x += imgFrame.size.width + gap;
    
    UILabel *titleLabel = createLabel(CGRectMake(x, 0, w-x, titleView.bounds.size.height), gNavBarTitleFont, nil, gNavBarTitleColor, gNavBarTitleShadowColor, CGSizeZero, NSTextAlignmentLeft, 1, NSLineBreakByTruncatingTail);
    titleLabel.text = title;
    
    [titleLabel.layer setShadowOpacity:gNavBarTitleShadowColor?1:0];
    [titleLabel.layer setShadowColor:[gNavBarTitleShadowColor CGColor]];
    [titleLabel.layer setShadowRadius:1];
    [titleLabel.layer setShadowOffset:CGSizeMake(0, 1)];
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    titleView = nil;
}
- (void)setTitle:(NSString *)title{
    [self setNavTitle:title];
    if (self.navigationItem.titleView && [self.navigationItem.titleView isKindOfClass:[UIButton class]]) {
        [(UIButton *)self.navigationItem.titleView setTitle:title forState:UIControlStateNormal];
    }else if(self.navigationItem.titleView && [self.navigationItem.titleView isKindOfClass:[UILabel class]]){
        [(UILabel *)self.navigationItem.titleView setText:title];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self awake];
    [self.view setBackgroundColor:ThemeViewBackgroundColor];
    if (self.navigationItem && !self.titleLabel) {
        CGRect rect = CGRectInset(self.navigationController.navigationBar.bounds, 60, 0);
        UILabel *titleLabel = createLabel(rect, gNavBarTitleFont, nil, gNavBarTitleColor, nil, CGSizeZero, NSTextAlignmentCenter, 0, NSLineBreakByTruncatingTail);
        [titleLabel setText:self.navTitle];
        DLOG(@"%@",gNavBarTitleShadowColor);
        [titleLabel.layer setShadowOpacity:gNavBarTitleShadowColor?1:0];
        [titleLabel.layer setShadowColor:[gNavBarTitleShadowColor CGColor]];
        [titleLabel.layer setShadowRadius:1];
        [titleLabel.layer setShadowOffset:CGSizeMake(0, 1)];
        [self.navigationItem setTitleView:titleLabel];
        [self setTitleLabel:titleLabel];
    }
}
- (void)addBackButton{
    if (!self.navigationItem) {
        return;
    }
    UIImage *backImg = [UIImage imageNamed:@"back"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backButton animated:YES];
}
- (void)goBack:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
- (void)viewDidUnload{
    [super viewDidUnload];
    DLOG(@"viewDidUnload & reset");
    [self reset];
}
- (void)reset{
    DLOG(@"[%@] reset...", NSStringFromClass([self class]));
}

-(id)loadViewFromNibNamed:(NSString*)nibName {
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:nibName
                                                          owner:self
                                                        options:nil];
    assert( objectsInNib.count == 1);
    return [objectsInNib objectAtIndex:0];
}
- (BOOL)shouldPopViewController:(UIViewController *)controller{
    return YES;
}
- (void)popViewControllerAnimated:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popViewController:(id)sender {
    if ( ![self shouldPopViewController:self]) {
        return;
    }
    [self popViewControllerAnimated:YES];
}

/********/
- (void)showMessage:(NSString *)msg duration:(float)duration{
    [BIndicator showMessage:msg duration:duration inView:self.view];
}
- (void)showMessage:(NSString *)msg{
    [BIndicator showMessage:msg inView:self.view];
}
- (void)showMessageAndFadeOut:(NSString *)msg{
    [BIndicator showMessage:msg duration:2.0 inView:self.view];
}
- (void)fadeOutAfterDelay:(float)t{
    [BIndicator fadeOutWithDelay:t];
}
- (void)fadeOut{
    [self fadeOutAfterDelay:0];
}

- (void)setHttpRequest:(id)request forKey:(NSString *)key{
    //AFHTTPRequestOperation *req = [self.requestPool valueForKey:key];
    //if (req && ![req isCancelled]) {
    //    [req cancel];
    //}
    [self.requestPool setValue:request forKey:key];    
}
- (BDropMenu*) topDropMenu{
    if (!_topDropMenu) {
        _topDropMenu = [[BDropMenu alloc] init];
        [_topDropMenu setItemHeight:28];
        [_topDropMenu setDelegate:self];
    }
    UIView *titleView = (UIButton *)self.navigationItem.titleView;
    _topDropMenu.offset = CGPointMake(titleView.bounds.size.width/2, titleView.bounds.size.height-2);
    [_topDropMenu setAnchor:titleView];
    return _topDropMenu;
}
- (void)showDropMenu:(id)sender{}
- (void)dealloc{
    for (NSString *key in [_requestPool allKeys]) {
        //AFHTTPRequestOperation *req = [self.requestPool valueForKey:key];
        //[req cancel];
    }
    ////
    ////
    ////
    ////
    ////
    //[super dealloc];
}
- (BOOL)shouldAutorotate{
    return NO;
}
@end
