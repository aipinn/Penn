//
//  BaseTabBarController.m
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

#import "PNHomeViewController.h"
#import "PNProfileViewController.h"
#import "PNFuncController.h"
#import "PNKitViewController.h"
#import "PNFundationController.h"

@interface BaseTabBarController ()

@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * imageArr;
@property (nonatomic, strong) NSArray * imageSelArr;
@property (nonatomic, strong) NSArray * clsNameArr;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self customTabBarAppearance];
    [self createControllers];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create Controllers

/**
 反射创建控制器
 */
- (void)createControllers{
    
    NSInteger i = 0;
    NSMutableArray * clsArr = [[NSMutableArray alloc] init];
    for (NSString * clsName in self.clsNameArr) {
        BaseViewController * vc = [[NSClassFromString(clsName) alloc] init];
        BaseNavigationController * navHome = [[BaseNavigationController alloc] initWithRootViewController:vc];
        navHome.tabBarItem.image = [[UIImage imageNamed:self.imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navHome.tabBarItem.selectedImage = [[UIImage imageNamed:self.imageSelArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navHome.tabBarItem.title = self.titleArr[i];
        [clsArr addObject:navHome];
        i++;
    }
    self.viewControllers = clsArr;
    
}




#pragma mark - Private Methods

/**
 tabbar 显示样式
 */
- (void)customTabBarAppearance{
    //1. 总体颜色
    //背景色 / tintColor
    //方法一:UIView的属性
    //    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    //方法二: UITabBar的特有属性
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:0.8 alpha:1]];
    //方法三:设置背景图片
    //    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@""]];
    
    //2.字体设置
    //方法一:简单设置
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor greenColor]];
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
    //方法二:可以更加多样化设置
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName:[UIColor darkTextColor]
    //                                                        } forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName:[UIColor purpleColor]
    //                                                        } forState:UIControlStateSelected];
    
    //3. 图片颜色
    //方法一:直接在Assets中选中tabbar的图片,在检视板中设置属性:sender as-->original image
    //方法二:在BaseTabbar中设置图片时使用图片的渲染模式:UIImageRenderingModeAlwaysOriginal
    //方法三:storyboard中:identity inspector 添加kvc属性
    
}

/**
 准备tabbar数据
 */
- (void)prepareData{
    self.titleArr = @[
                      @"Home",@"Kit",@"Fundation",@"Func",@"Profile"
                      ];
    self.imageArr = @[
                      @"tab_bar_discover",
                      @"tab_bar_pro",
                      @"tab_bar_add",
                      @"tab_bar_msg",
                      @"tab_bar_my"
                      ];
    self.imageSelArr = @[
                         @"tab_bar_discover_selected",
                         @"tab_bar_pro_selected",
                         @"tab_bar_add_selected",
                         @"tab_bar_msg_selected",
                         @"tab_bar_my_selected"
                         ];
    
    self.clsNameArr = @[
                        @"PNHomeViewController",
                        @"PNKitViewController",
                        @"PNFundationController",
                        @"PNFuncController",
                        @"PNProfileViewController"
                        ];
}

@end
