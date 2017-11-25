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
    


    return YES;
}




@end
