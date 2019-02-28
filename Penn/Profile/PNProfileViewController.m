//
//  PNProfileViewController.m
//  Penn
//
//  Created by PENN on 2017/12/2.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNProfileViewController.h"
#import "PNDataStructureController.h"
#import "PNImgViewCell.h"

@interface PNProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PNProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
- (IBAction)dataStructure:(id)sender {
    PNDataStructureController * data = [[PNDataStructureController alloc] init];
    [self.navigationController pushViewController:data animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[PNImgViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNImgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.num = 3;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20000;
}


@end
