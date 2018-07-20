//
//  PNRuntimeController.m
//  Penn
//
//  Created by emoji on 2018/7/19.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNRuntimeController.h"
#import "PNMsgForward.h"
#import "PNDynamicMethod.h"

@interface PNRuntimeController ()

@end

@implementation PNRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * btn = [UIButton new];
    btn.titleLabel.text = @"消息转发测试";
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(0, 100, 100, 60);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testMsgForward) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)testMsgForward{
    PNDynamicMethod * dynamic = [PNDynamicMethod new];
     [dynamic performSelector:@selector(doSomething)];
}

@end
