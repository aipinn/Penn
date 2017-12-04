//
//  BaseViewController.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation BaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MYColor(39,40,34);


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * clsName = self.dataSource[indexPath.row];
    BaseViewController * vc = [[NSClassFromString(clsName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - UI

- (void)setupUI{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - Access

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
