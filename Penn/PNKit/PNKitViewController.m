//
//  PNKitViewController.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKitViewController.h"
#import "PNButton.h"
#import "UIButton+Addition.h"
#import "PNButton+Addition.h"

@interface PNKitViewController ()

@end

@implementation PNKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    PNButton * button = [[PNButton alloc] initWithFrame:CGRectMake(10, 100, 0, 0)];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"按下试试" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    [button imageRight];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
