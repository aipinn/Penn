//
//  BaseNavigationController.m
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "BaseNavigationController.h"
#import "PNHomeViewController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self customNavigationBarAppearance];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - overwrite

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //0. push之前隐藏/展示tabbar
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }else{
        viewController.hidesBottomBarWhenPushed = NO;
        
    }
    [super pushViewController:viewController animated:animated];
    
    //1.获取特定类的所有导航类条,并修改属性
    if ([viewController isKindOfClass:[PNHomeViewController class]]) {
        
        UINavigationBar * bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[UIViewController class]]];
        //Note: These properties must both be set if you want to customize the back indicator image.
        bar.backIndicatorImage = [UIImage imageNamed:@"record"];
        bar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"record"];
        //设置特定颜色
        //        bar.tintColor = [UIColor purpleColor];
    }
    
    //2. 设置返回:一般是最后一级为'上一级的标题'; 更深层次为"返回"
    //2.1 push之后隐藏活显示tabbar
    if (self.viewControllers.count == 1) {

    }else{
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:nil
                                                                                          action:nil];

    }
    
    //3.自定义返回按钮
    if (self.viewControllers.count > 1) {
        //1. 自定义设置返回按钮,其x=16.5, 原生的返回按钮x=6.5
        //2. 会使侧滑返回手势失效
        //3. 一般不使用
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backRed"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    }
    

    
    
}
#pragma mark - Action
- (void)back{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)customNavigationBarAppearance{
    //1. 整体背景
    //    //a. UIview属性bg
    //    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    //    //b. TintColor
    //     [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    //    //c. 背景图片
    //        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    //2.item
    // 左右item的颜色
    //[[UINavigationBar appearance] setTintColor:[UIColor greenColor]];
    // 标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:
                                                               [UIColor darkGrayColor]
                                                           }];
    
    
}

@end
