//
//  BaseViewController.h
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

/**
 设置UI
 */
- (void)setupUI;



@end
