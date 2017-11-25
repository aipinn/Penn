//
//  AppDelegate.m
//  Penn
//
//  Created by SanRong on 2017/9/7.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabBarController * tabBar = [[BaseTabBarController alloc] init];
    window.rootViewController = tabBar;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    
    [self customTabBarAppearance];
    
    return YES;
}

/**
 tabbar 显示样式
 */
- (void)customTabBarAppearance{
    //1. 总体颜色
    //背景色 / tintColor
    //方法一:UIView的属性
    //[[UITabBar appearance] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    //方法二: UITabBar的特有属性
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:0.8 alpha:1]];

    
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


@end
