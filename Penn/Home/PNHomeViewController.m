//
//  PNHomeViewController.m
//  Penn
//
//  Created by PENN on 2017/9/9.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNHomeViewController.h"
#import "Penn-Swift.h"

static NSString * const reuseCellId = @"HomeCell";

@interface PNHomeViewController ()





@end

@implementation PNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    //摇一摇
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self setupUI];
    [self.dataSource addObjectsFromArray:@[
                                           @"PNKitViewController",
                                           @"PNSocketController",
                                           @"PNFundationController",
                                           @"PNMLZListController",
                                           @"PNCoreTextViewController",
                                           ]];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
#pragma mark - 摇一摇回调方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇动");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换网络环境" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"正式环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FormalCircumstances"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"测试环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FormalCircumstances"];
    }]];
    [self presentViewController:alert animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] boolForKey:@""];
    }];
    
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇动结束");
    
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇动取消");
    
}


#pragma mark - TableView Delegate/DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * clsName = self.dataSource[indexPath.row];
    BaseViewController * vc = [[NSClassFromString(clsName) alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Action

- (void)nextSwift{
    
    PNSwiftViewController * swift = [[PNSwiftViewController alloc] init];
    [self.navigationController pushViewController:swift animated:YES];
}

#pragma mark - Private Methods

- (void)setupUI{
    [super setupUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellId];
    
    //下一级:swift
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bottomNav-forwardEngaged"] style:UIBarButtonItemStylePlain target:self action:@selector(nextSwift)];
    self.navigationItem.rightBarButtonItem = right;
    //左边按钮
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"试试" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = left;
    

    
}



@end
