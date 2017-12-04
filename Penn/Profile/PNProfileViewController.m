//
//  PNProfileViewController.m
//  Penn
//
//  Created by SanRong on 2017/12/2.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNProfileViewController.h"
#import "PNLoginView.h"

@interface PNProfileViewController ()

@end

@implementation PNProfileViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addPopLoginView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - pop loginView

- (void)addPopLoginView{
    
    PNLoginView * loginView = [PNLoginView loginView];
    //loginView.bounds = CGRectMake(self.view.centerX, 0, 200, 150);
    loginView.centerX = self.view.centerX;
    [self.view addSubview:loginView];
    //1. 创建spring动画
    POPSpringAnimation * anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    //2. 设置动画属性
    anim.fromValue = @(0);
    anim.toValue = @(self.view.centerY);
    //[0, 20] default 12
    anim.springSpeed = 10;
    //anim.velocity = @(20);
    //[0, 20] default 4
    anim.springBounciness = 20;
    //3. 添加动画
    [loginView pop_addAnimation:anim forKey:nil];
}

@end
