//
//  PNChildViewController.m
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNChildViewController.h"

@interface PNChildViewController ()

@end

@implementation PNChildViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.themeColor;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 200, 200, 50);
    [btn setTitle:[NSString stringWithFormat:@"%@_dismiss",self.title] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)pop:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
