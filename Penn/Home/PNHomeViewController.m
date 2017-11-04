//
//  PNHomeViewController.m
//  Penn
//
//  Created by SanRong on 2017/9/9.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNHomeViewController.h"
#import "PNSocketController.h"

#import "Global.h"

static NSString * const socketCellIdentifer = @"PNSocketController";

@interface PNHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;

@end

@implementation PNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
}

#pragma mark - TableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:socketCellIdentifer forIndexPath:indexPath];
    cell.textLabel.text = NSStringFromClass([PNSocketController class]);
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PNSocketController * socketVC = [[PNSocketController alloc]init];
    
    [self.navigationController pushViewController:socketVC animated:YES];
    
}

#pragma mark - Private Methods

- (void)configTableView{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
 
//    [self.tableView registerNib:[UINib nibWithNibName:socketCellIdentifer bundle:[NSBundle mainBundle]] forCellReuseIdentifier:socketCellIdentifer];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:socketCellIdentifer];
}


@end
