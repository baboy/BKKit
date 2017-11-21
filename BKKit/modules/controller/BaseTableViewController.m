//
//  AppBaseTableViewController.m
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Global.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)dealloc{
    [self.tableView setDelegate:nil];
    ////
    //[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tableStyle = UITableViewStylePlain;
    }
    return self;
}
- (id)init{
    if(self = [super init]){
        self.tableStyle = UITableViewStylePlain;
    }
    return self;
}
- (void)reset{
    [super reset];
    self.tableView = nil;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if (!self.tableView) {
        self.tableView = /*AUTORELEASE*/([[TableView alloc] initWithFrame:self.view.bounds style:self.tableStyle]);
        self.tableView.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIEdgeInsets contentOriginInset = UIEdgeInsetsZero;
        if (!self.navigationController.navigationBar.isHidden) {
            CGFloat statusBarHeight = [APP isStatusBarHidden]?0:[APP statusBarFrame].size.height;
            contentOriginInset.top = self.navigationController.navigationBar.bounds.size.height + statusBarHeight;
        }
        if (self.tabBarController && !self.hidesBottomBarWhenPushed) {
            contentOriginInset.bottom = self.tabBarController.tabBar.bounds.size.height;
        }
        _tableView.contentOriginInset = contentOriginInset;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self.view addSubview:_tableView];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView scrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
