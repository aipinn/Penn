//
//  PNHomeViewController.m
//  Penn
//
//  Created by SanRong on 2017/9/9.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNHomeViewController.h"
#import "PNSocketController.h"
#import "PNKitViewController.h"
#import "PNFundationController.h"

#import "Global.h"

static NSString * const reuseCellId = @"HomeCell";

@interface PNHomeViewController ()

@end

@implementation PNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.dataSource addObjectsFromArray:@[
                                           @"PNKitViewController",
                                           @"PNSocketController",
                                           @"PNFundationController"
                                           ]];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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

#pragma mark - Private Methods

- (void)setupUI{
    [super setupUI];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellId];
}



@end
