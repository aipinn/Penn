//
//  PNClassClustersViewController.m
//  Penn
//
//  Created by emoji on 2018/8/3.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNClassClustersViewController.h"

@interface PNClassClustersViewController ()

@end

@implementation PNClassClustersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    id arr = [[NSArray alloc] init];
    id arr1 = [NSArray array];
    if ([arr class] != [NSArray class]) {
        NSLog(@"arr is class:%@", [arr class]);//__NSArray0
    }
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 100, 100, 30);
    [btn setTitle:@"i am button" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    if ([btn class] != [UIButton class]) {
        NSLog(@"btn is class: %@",[btn class]);
    }else{
        NSLog(@"btn is class: %@",[UIButton class]);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
