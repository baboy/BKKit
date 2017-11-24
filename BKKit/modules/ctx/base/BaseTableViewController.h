//
//  AppBaseTableViewController.h
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseViewController.h"
#import "TableView.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, TableViewDelegate>

@property (nonatomic, strong) IBOutlet TableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableStyle;
@end
