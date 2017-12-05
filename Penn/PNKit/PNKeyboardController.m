//
//  PNKeyboardController.m
//  Penn
//
//  Created by SanRong on 2017/12/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKeyboardController.h"

@interface PNKeyboardController ()<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomCons;

@end

@implementation PNKeyboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //0. 设置代理
    self.tv1.delegate = self;
    //self.tv2.delegate = self;
    self.tf.delegate = self;
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:self.tv1];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self.tv1 becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tv1 resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - Private Methods

- (void)KeyboardWillChangeFrame:(NSNotification *)notify{
    //1. 获取键盘rect
    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //2. 更改toolbar的底部约束常量, 为负值
    self.toolBarBottomCons.constant = -self.view.bounds.size.height + rect.origin.y;
    //3. 动画效果
    double durTime = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:durTime animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)changeKeyboard{
    //1. 创建新视图,指定高度即可
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 253)];
    view.backgroundColor = [UIColor orangeColor];
    //2. 设置视图
    self.tv1.inputView = view;
    //3. 刷新视图
    [self.tv1 reloadInputViews];
    //4. option: 设置辅助视图
    self.tv1.inputAccessoryView = self.toolbar;

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self changeKeyboard];
}

@end
