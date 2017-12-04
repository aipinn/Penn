//
//  PNKeyboardController.m
//  Penn
//
//  Created by SanRong on 2017/12/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKeyboardController.h"

@interface PNKeyboardController ()

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation PNKeyboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 创建新视图
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 253)];
    //2. 设置视图
    self.tv1.inputView = view;    
    //3. 刷新视图
    [self.tv1 reloadInputViews];
    //4. option: 设置辅助视图
    //self.tv1.inputAccessoryView = self.toolbar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


@end
